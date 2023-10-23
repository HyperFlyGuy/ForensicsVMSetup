# ForensicsVMSetup
Uses Powershell to easily set up Forensic tooling in a Windows VM. 
-----------------------------------------------------------------------
Step One:
-Go to "https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3&WT.mc_id=THOMASMAURER-blog-thmaure#winget". The article shows multiple methods for installing Powershell 7.x, I used the MSI Installer and it worked fine.

Step Two:
- Make sure you disable the Microsoft Security Suite (Tamper Protection, Virus and Threat Protection, App Browser Control, etc). If you want to be extra safe you can set an exclusion on your C Drive.
-
-Open a Powershell Administrative Prompt and then run "install.ps1"



Current Issues:
Need to install Shadow explorer  another way besides Chocolatey. It causes the script to hang
Need to open a new powershell prompt once chocolatey is done so git is recognized as a command. Boxstarter should take care of this.
