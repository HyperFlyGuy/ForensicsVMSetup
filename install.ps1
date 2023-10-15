
Set-ExecutionPolicy Bypass -Scope Process -Force
#Checks to make sure our install path exists. If not it will create it.
$installpath = 'C:\Program Files\Forensic Tools\'
If (!(test-path $installpath))
{
    New-Item -ItemType Directory -Path $installpath
    New-Item -ItemType Directory -Path $installpath\Acquisiton
    New-Item -ItemType Directory -Path $installpath\Parsing
    New-Item -ItemType Directory -Path $installpath\Analysis
    New-Item -ItemType Directory -Path $installpath\Reporting
    New-Item -ItemType Directory -Path $installpath\misc
    New-Item -ItemType Directory -Path $installpath\Delete
}

if(!(Test-Path -path "$env:ProgramData\Chocolatey")){
#Installs Chocolatey package manager if it is not installed
Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Install-ChocPackages
}
else{
Install-ChocPackages
}



function Install-ChocPackages {
    #Establishing arrays for the  Chocolatey Packages
    $Packages = 'chocolatey-core.extension', 'chocolatey-compatibility.extension', 'chocolatey-dotnetfx.extension', 'dotnet4.5', 'dotnet4.6.1', 'flashplayeractivex', 'flashplayerplugin', 'javaruntime', 'adobeair', 'activeperl', 'adobereader', 'googlechrome', 'firefox', 'notepadplusplus.install', 'python', '7zip.install', 'libreoffice-fresh', 'greenshot', 'openvpn', 'obs-studio.install', 'putty', 'access-data-registry-viewer', 'nirlauncher', 'photorec', 'hindsight-gui', 'exiftool', 'hxd', 'sysinternals ', 'jq', 'hindsight', 'hindsight-gui', 'wireshark', 'tableau-imager', 'hibernation-recon', 'arsenalimagemounter', 'dcode', 'bulk-extractor', 'aurora-ir', 'volatility3', 'mft2csv', 'logfileparser', 'ileapp-gui', 'usnjrnl2csv', 'aleapp', 'sleuthkit', 'radare2', 'autopsy', 'defraggler', 'esedatabaseview', 'free-pst-reader', 'free-ost-reader', 'logparser', 'plaso', 'timelineexplorer', 'winprefetchview', 'regripper', 'shadowexplorer', 'sqlitebrowser', 'strings', 'thumbs-viewer', 'uniextract', 'unxutils', 'userassistview', 'cyberchef', 'yara'
    #Begins install of Chocolatey packages
    foreach ($elem in $Packages) {
        choco install $elem  --yes --ignore-checksum
    }
}

function Install-ZippedPrograms{
    #Downloads all the zip files 
    $counter=0
    $ZipProgramsName = 'Cylr-win', 'Cylr-mac', 'Cylr-linux', 'MiTec Structured Storage View', 'MiTec Windows Registry Analyzer', 'SPL Viewer', 'vsc toolset', 'SQLIte Deleted Records Parser', 'ThumbCache Viewer', 'Woanware RegRipperRunner' 
    $ZipPrograms = 'https://github.com/orlikoski/CyLR/releases/download/2.2.0/CyLR_win-x64.zip', 'https://github.com/orlikoski/CyLR/releases/download/2.2.0/CyLR_osx-x64.zip', 'https://github.com/orlikoski/CyLR/releases/download/2.2.0/CyLR_linux-x64.zip', 'http://www.mitec.cz/Downloads/SSView.zip', 'http://www.mitec.cz/Downloads/WRR.zip', 'https://www.lvbprint.de/files/splviewer/SPLView64.zip', 'https://df-stream.com/download/318/', 'https://github.com/mdegrazia/SQLite-Deleted-Records-Parser/releases/download/v.1.1/sqlparse_GUI.zip', 'https://github.com/thumbcacheviewer/thumbcacheviewer/releases/download/v1.0.3.9/thumbcache_viewer_64.zip', 'https://github.com/woanware/RegRipperRunner/raw/master/Release/RegRipperRunner.v.1.0.3.zip'
    foreach($elem in $ZipPrograms){
        $FolderName = $ZipProgramsName[$counter]
        Invoke-WebRequest -Uri $ZipPrograms[$counter] -outfile "$installpath\Delete\$counter.zip"
        Expand-Archive -Path "$installpath\Delete\$counter.zip" -DestinationPath $installpath\$FolderName
        $counter++
    }
    }
function Install-GitPrograms{
    $GitCloneFolderNames = 'one drive explorer', 'shellbags python parser', 'skype parser', 'srum dump', 'Woanware Autorunner', 'Woanware Reg-Entropy-Scanner', 'Woanware Forensic User Info', 'Woanware JumpLister', 'ShimCache Parser', 'Woanware USB Device Forensics', 'Volatility distrom', 'Volatility Twitter Facebook Plugins' 
    $GitClonePrograms = 'https://github.com/Beercow/OneDriveExplorer.git', 'https://github.com/williballenthin/shellbags.git', 'https://github.com/TheAlbatrossCodes/skype-parser.git', 'https://github.com/MarkBaggett/srum-dump.git', 'https://github.com/woanware/autorunner.git', 'https://github.com/woanware/reg-entropy-scanner.git', 'https://github.com/woanware/ForensicUserInfo.git', 'https://github.com/woanware/JumpLister.git', 'https://github.com/mandiant/ShimCacheParser.git', 'https://github.com/woanware/usbdeviceforensics.git', 'https://github.com/gdabah/distorm.git', 'https://github.com/jeffbryner/volatilityPlugins.git'
    $counter = 0
    foreach($elem in $GitClonePrograms){
        $FolderName= $installpath + $GitCloneFolderNames[$counter] 
        git clone $GitClonePrograms[$counter] $FolderName
        $counter++
    }
    }

function Install-ExePrograms{
    $ExeProgramsNames = 'SAMInside.exe', 'SimpleFileParser.exe', 'volatility-2.3.1.standalone.exe', 'sqlparse_CLI.exe', 'sqlparse_v1.1.py'
    $ExePrograms = 'https://us.softradar.com/static/products/saminside/distr/2.7.0.1/saminside_softradar-com.exe', 'https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/simple-file-parser/Simple%20File%20Parser%20v1.5.1.exe', 'https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/volatility/volatility-2.3.1.standalone.exe', 'https://github.com/mdegrazia/SQLite-Deleted-Records-Parser/releases/download/v.1.1/sqlparse_CLI.exe', 'https://github.com/mdegrazia/SQLite-Deleted-Records-Parser/releases/download/v.1.1/sqlparse_v1.1.py'
    $counter=0
    foreach($elem in $ExePrograms){ 
        Invoke-WebRequest -Uri $ExePrograms[$counter] -OutFile $installpath\$ExeProgramsNames[$counter]
        $counter++
    }
    }    