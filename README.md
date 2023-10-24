# ForensicsVMSetup
Uses Powershell to easily set up Forensic tooling in a Windows VM. 
-----------------------------------------------------------------------
Step One:
-Go to "https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3&WT.mc_id=THOMASMAURER-blog-thmaure#winget". The article shows multiple methods for installing Powershell 7.x, I used the MSI Installer and it worked fine.

Step Two:
- Make sure you disable the Microsoft Security Suite (Tamper Protection, Virus and Threat Protection, App Browser Control, etc). If you want to be extra safe you can set an exclusion on your C Drive.
-
-Open a Powershell Administrative Prompt and then run "install.ps1"



To Do:
-Need to install Shadow explorer, winprefetch, esedatabaseviewer another way besides Chocolatey. It causes the script to hang
-Need a centralized folder for all the tools that allows proper organization
-Verify that all the programs work and if any further installation is required. Mainly with the Git Repos


