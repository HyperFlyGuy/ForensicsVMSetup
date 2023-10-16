Set-ExecutionPolicy Bypass -Scope Process -Force


$index=Import-Csv -path $PSScriptRoot\ExtraToolsIndex.txt
    foreach($obj in $index)
    {
    if ($obj.Type -eq "zip"){
        Write-Host $obj.Name " is a zip"
    }
    elseif ($obj.Type -eq "exe") {
         Invoke-WebRequest -Uri $obj.DownloadURL -OutFile C:\Users\koh\Downloads
         }
    elseif ($obj.Type -eq "git") {
        Write-Host $obj.Name " is a git"
    }
    elseif ($obj.Type -eq "manual") {
        Write-Host $obj.Name " is a manual"
    }
    }
    