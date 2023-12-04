# ForensicsVMSetup
Uses Powershell to easily set up Forensic tooling in a Windows VM. 
-----------------------------------------------------------------------
Prerequisites:
A Windows 11/10 VM
-----------------------------------------------------------------------
Step One:
-Go to "https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3&WT.mc_id=THOMASMAURER-blog-thmaure#winget". The article shows multiple methods for installing Powershell 7.x, I used the MSI Installer and it worked fine. This step may not be completely necessary but will ensure you run into no issues.
Step Two:
- Make sure you disable the Microsoft Security Suite (Tamper Protection, Virus and Threat Protection, App Browser Control, etc). If you want to be extra safe you can set an exclusion on your C Drive.
Step Three:
-Open a Powershell Administrative Prompt set execution policy to unrestricted, and then run "install.ps1"
Step Four:
-The script was designed to be fire and forget however I recommend monitoring it a bit to make sure it doesn't hang. With a good internet connection it should only take about 30 minutes.


Development To Do's:
-Need to install Shadow explorer, winprefetch, esedatabaseviewer another way besides Chocolatey. It causes the script to hang
-Verify that all the programs work and if any further installation is required. Mainly with the Git Repos


