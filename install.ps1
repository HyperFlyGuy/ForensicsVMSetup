
$Index=Import-Csv -path $PSScriptRoot\ExtraToolsIndex.txt
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
function New-FileStructure {
    #Checks to make sure our install path exists. If not it will create it.
    $installpath='C:\Program Files\Forensic Tools\'
    If (-not (test-path $installpath))
    {
        New-Item -ItemType Directory -Path $installpath
        New-Item -ItemType Directory -Path $installpath\Acquisiton
        New-Item -ItemType Directory -Path $installpath\Parsing
        New-Item -ItemType Directory -Path $installpath\Analysis
        New-Item -ItemType Directory -Path $installpath\Reporting
        New-Item -ItemType Directory -Path $installpath\misc
        New-Item -ItemType Directory -Path $installpath\Delete
    } 
    else
    {
        Write-Host "Your install path is: $installpath"
    }
    if (-not (Test-Path -Path "$env:ProgramData\Chocolatey\choco.exe")) {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    else{
        Write-Host "Chocolatey is installed"
    }
}
function Install-Program {
    param (
        $Name,
        $Type,
        $Category,
        $DownloadURL
    )
    $dest = 'C:\Program Files\Forensic Tools\' + $Category
    switch ($Type) 
    {
        'chocolatey' {choco install $Name --yes --ignore-checksum}
        'zip' {
            Invoke-WebRequest -Uri $DownloadURL -OutFile "$dest.zip"
            Expand-Archive -Path "$dest.zip" -DestinationPath $dest
            Remove-Item -Path "$dest.zip"
        }
        'exe' {Invoke-WebRequest -Uri $DownloadURL -OutFile "$dest.exe"}
        'git' {git clone $DownloadURL $dest}
        'manual' {Write-Host "Installation for $Name is manual."}
        default {Write-Warning "Unsupported program type: $Type"}
    }
}

function Get-Programs {
        param (
        $program
        )
    $dest = 'C:\Program Files\Forensic Tools\' + $Category
    $counter=0
     foreach($elem in $program){
         switch ($program.Type[$counter]) 
         {
             'chocolatey' {choco install $program.Name[$counter] --yes --ignore-checksum}
             'zip' {
                 Invoke-WebRequest -Uri $program.DownloadURL[$counter] -OutFile "$dest.zip"
                 Expand-Archive -Path "$dest.zip" -DestinationPath $dest
                 Remove-Item -Path "$dest.zip"
             }
             'exe' {Invoke-WebRequest -Uri $program.DownloadURL[$counter] -OutFile "$dest.exe"}
             'git' {git clone $program.DownloadURL[$counter] $dest}
             'manual' {Write-Host "Installation for $program.Name[$counter] is manual."}
             default {Write-Warning "Unsupported program type: $program.Type[$counter]"}
         }
         $counter++
    }
    }

Show-System
New-FileStructure
Get-Programs $Index