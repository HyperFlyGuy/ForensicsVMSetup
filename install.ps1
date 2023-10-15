
Set-ExecutionPolicy Bypass -Scope Process -Force
#Checks to make sure our install path exists. If not it will create it.
$installpath = 'C:\Program Files\Forensic Tools'
If (!(test-path $installpath))
{
    New-Item -ItemType Directory -Path $installpath
    New-Item -ItemType Directory -Path $installpath\Acquisiton
    New-Item -ItemType Directory -Path $installpath\Parsing
    New-Item -ItemType Directory -Path $installpath\Analysis
    New-Item -ItemType Directory -Path $installpath\Reporting
    New-Item -ItemType Directory -Path $installpath\misc
}

#Establishing arrays for the  Chocolatey Packages
$Packages = 'chocolatey-core.extension', 'chocolatey-compatibility.extension', 'chocolatey-dotnetfx.extension', 'dotnet4.5', 'dotnet4.6.1', 'flashplayeractivex', 'flashplayerplugin', 'javaruntime', 'adobeair', 'activeperl', 'adobereader', 'googlechrome', 'firefox', 'notepadplusplus.install', 'python', '7zip.install', 'libreoffice-fresh', 'greenshot', 'openvpn', 'obs-studio.install', 'putty', 'access-data-registry-viewer', 'nirlauncher', 'photorec', 'hindsight-gui', 'exiftool', 'hxd', 'sysinternals ', 'jq', 'hindsight', 'hindsight-gui', 'wireshark', 'tableau-imager', 'hibernation-recon', 'arsenalimagemounter', 'dcode', 'bulk-extractor', 'aurora-ir', 'volatility3', 'mft2csv', 'logfileparser', 'ileapp-gui', 'usnjrnl2csv', 'aleapp', 'sleuthkit', 'radare2', 'autopsy', 'defraggler', 'esedatabaseview', 'free-pst-reader', 'free-ost-reader', 'logparser', 'plaso', 'timelineexplorer', 'winprefetchview', 'regripper', 'shadowexplorer', 'sqlitebrowser', 'strings', 'thumbs-viewer', 'uniextract', 'unxutils', 'userassistview', 'cyberchef', 'yara'


if(!(Test-Path -path "$env:ProgramData\Chocolatey")){
#Installs Chocolatey package manager if it is not installed
Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Install-PSPackages
}
else{
Install-PSPackages
}



function Install-PSPackages {
    #Begins install of Chocolatey packages
    foreach ($elem in $Packages) {
        choco install $elem  --yes --ignore-checksum
    }
}

function Install-EXPrograms{

    }
