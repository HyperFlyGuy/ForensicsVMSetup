function refresh-path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
                ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
}
function New-FileStructure {
    #Checks to make sure our install path exists. If not it will create it.
    $installpath='C:\Program Files\Forensic Tools\'
    If (-not (test-path $installpath))
    {
        New-Item -ItemType Directory -Path $installpath
        New-Item -ItemType Directory -Path $installpath\Acquisition
        New-Item -ItemType Directory -Path $installpath\Parser
        New-Item -ItemType Directory -Path $installpath\Analysis
        New-Item -ItemType Directory -Path $installpath\Reporting
    } 
    else
    {
        Write-Host "Your install path is: $installpath"
    }
    if (-not (Test-Path -Path "$env:ProgramData\Chocolatey\choco.exe")) 
    {
        #Checks for chocolatey install if not it will install it along with boxstarter
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force
    }
    else{
        Write-Host "Chocolatey is installed"
    }
}
function Show-System {
    # Ensure execution policy is unrestricted
    Write-Host "[+] Checking if execution policy is unrestricted..."
    if ((Get-ExecutionPolicy).ToString() -ne "Unrestricted") {
        Write-Host "`t[!] Please run this script after updating your execution policy to unrestricted" -ForegroundColor Red
        Write-Host "`t[-] Hint: Set-ExecutionPolicy Unrestricted" -ForegroundColor Yellow
        Read-Host "Press any key to exit..."
        exit 1
    } else {
        Write-Host "`t[+] Execution policy is unrestricted" -ForegroundColor Green
        Start-Sleep -Milliseconds 500
    }

    # Check if Tamper Protection is disabled
    Write-Host "[+] Checking if Windows Defender Tamper Protection is disabled..."
    try {
        $tpEnabled = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" -Name "TamperProtection" -ErrorAction Stop
        if ($tpEnabled.TamperProtection -eq 5) {
            Write-Host "`t[!] Please disable Tamper Protection, reboot, and rerun installer" -ForegroundColor Red
            Write-Host "`t[+] Hint: https://support.microsoft.com/en-us/windows/prevent-changes-to-security-settings-with-tamper-protection-31d51aaa-645d-408e-6ce7-8d7f8e593f87" -ForegroundColor Yellow
            Write-Host "`t[+] Hint: https://www.tenforums.com/tutorials/123792-turn-off-tamper-protection-windows-defender-antivirus.html" -ForegroundColor Yellow
            Write-Host "`t[+] Hint: https://github.com/jeremybeaume/tools/blob/master/disable-defender.ps1" -ForegroundColor Yellow
            Write-Host "`t[+] Hint: https://lazyadmin.nl/win-11/turn-off-windows-defender-windows-11-permanently/" -ForegroundColor Yellow
            Write-Host "`t[+] You are welcome to continue, but may experience errors downloading or installing packages" -ForegroundColor Yellow
            Write-Host "`t[-] Do you still wish to proceed? (Y/N): " -ForegroundColor Yellow -NoNewline
            $response = Read-Host
            if ($response -notin @("y","Y")) {
                exit 1
            }
        } else {
            Write-Host "`t[+] Tamper Protection is disabled" -ForegroundColor Green
            Start-Sleep -Milliseconds 500
        }
    } catch {
        Write-Host "`t[+] Tamper Protection is either not enabled or not detected" -ForegroundColor Yellow
        Write-Host "`t[-] Do you still wish to proceed? (Y/N): " -ForegroundColor Yellow -NoNewline
        $response = Read-Host
        if ($response -notin @("y","Y")) {
            exit 1
        }
        Start-Sleep -Milliseconds 500
        write-host "check done"
    }

    # Check if Defender is disabled
    Write-Host "[+] Checking if Windows Defender service is disabled..."
    $defender = Get-Service -Name WinDefend -ea 0
    if ($null -ne $defender) {
        if ($defender.Status -eq "Running") {
            Write-Host "`t[!] Please disable Windows Defender through Group Policy, reboot, and rerun installer" -ForegroundColor Red
            Write-Host "`t[+] Hint: https://stackoverflow.com/questions/62174426/how-to-permanently-disable-windows-defender-real-time-protection-with-gpo" -ForegroundColor Yellow
            Write-Host "`t[+] Hint: https://www.windowscentral.com/how-permanently-disable-windows-defender-windows-10" -ForegroundColor Yellow
            Write-Host "`t[+] Hint: https://github.com/jeremybeaume/tools/blob/master/disable-defender.ps1" -ForegroundColor Yellow
            Write-Host "`t[+] You are welcome to continue, but may experience errors downloading or installing packages" -ForegroundColor Yellow
            Write-Host "`t[-] Do you still wish to proceed? (Y/N): " -ForegroundColor Yellow -NoNewline
            $response = Read-Host
            if ($response -notin @("y","Y")) {
                exit 1
            }
        } else {
            Write-Host "`t[+] Defender is disabled" -ForegroundColor Green
            Start-Sleep -Milliseconds 500
        }
    }
}
function Install-OtherPrograms {
    param (
        $Index,
        $cred
        )
    ForEach ($obj in $Index) {
         $dest = "C:\Program Files\Forensic Tools\" + $obj.Category + "\" + $obj.name
         switch ($obj.Type)
         {
            'chocolatey'{
                if (-not (Test-Path -Path "$env:ProgramData\Chocolatey\lib\$($obj.Name)")) {
                    Write-Host "############################################################"
                    Write-Host ("[PROGRESS:] $($obj.Name) is now going to be installed!") -ForegroundColor Black -BackgroundColor Yellow
                    Install-BoxstarterPackage -PackageName $obj.Name -Credential $cred -DisableReboot
                    Write-Host ("[COMPLETE:] $($obj.Name) has finished its installation!") -ForegroundColor White -BackgroundColor Green
                }
                else {
                    Write-Host "############################################################"
                    Write-Host "$($obj.Name) was already installed!!!"  -ForegroundColor White -BackgroundColor Green
                }

            }
            'zip' {
                if (-not (Test-Path -Path $dest)){
                    Invoke-WebRequest -Uri $($obj.DownloadURL) -OutFile "$($dest).zip"
                    Expand-Archive -Path "$($dest).zip" -DestinationPath "$($dest)"
                    Remove-Item -Path "$($dest).zip"
                }
                else {
                    Write-Host "############################################################"
                    Write-Host "$($obj.Name) was already installed!!!"  -ForegroundColor DarkGreen -BackgroundColor Green
                    Write-Host "############################################################"
                }

            }
            'exe' {
                if (-not (Test-Path -Path "$($dest).exe")){
                    Invoke-WebRequest -Uri $obj.DownloadURL -OutFile "$($dest).exe"
                }
                else {
                    Write-Host "############################################################"
                    Write-Host "$($obj.Name) was already installed!!!"  -ForegroundColor White -BackgroundColor Green
                }
            }
            'git' {
                if (-not (Test-Path -Path $dest)){
                    git clone $obj.DownloadURL $($dest)
                }
                else {
                    Write-Host "############################################################"
                    Write-Host "$($obj.Name) was already installed!!!"  -ForegroundColor DarkGreen -BackgroundColor Green
                    Write-Host "############################################################"
                }
                }
            'manual' {
                Write-Host "############################################################"
                Write-Host ("Installation for " + $obj.Name + " is manual. Please visit " + $obj.DownloadURL + " and fill out the form.")
                Write-Host "############################################################"}
            default {Write-Warning "Unsupported program type: " + $obj.Type}
         }
         refresh-path
    }
}
function New-Shortcuts {
    param (
        $Index
    )
    foreach($obj in $Index){
        if($obj.Type -eq "chocolatey" -and ($obj.Category -eq "Acquisition" -or $obj.Category -eq "Parser" -or $obj.Category -eq "Analysis" -or $obj.Category -eq "Reporting")){
            $ShortcutFile = "C:\Program Files\Forensic Tools\" + $obj.Category + "\" + $obj.name + ".lnk"
            $TargetFile = $obj.InstallPath
            $WScriptShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
            $Shortcut.TargetPath = $TargetFile
            $Shortcut.Save()
        }

    }
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut("$DesktopPath\Forensic Tools.lnk")
    $Shortcut.TargetPath = "C:\Program Files\Forensic Tools"
    $Shortcut.Save()
}
function Main {
    $Index=Import-Csv -path .\ExtraToolsIndex.txt
    Show-System
    $cred=Get-Credential
    New-FileStructure
    Install-OtherPrograms $Index $cred
    New-Shortcuts $Index
}
Main