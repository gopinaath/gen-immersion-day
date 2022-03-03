<powershell>

Import-Module ServerManager;
Install-WindowsFeature Web-Server -IncludeManagementTools -IncludeAllSubFeature
remove-item -recurse c:\inetpub\wwwroot\*
(New-Object System.Net.WebClient).DownloadFile("https://static.us-east-1.prod.workshops.aws/public/00dcbd1d-5df0-4500-861e-5b6581d81d3f//static/common/ec2_web_hosting/ec2-windows.zip", "c:\inetpub\wwwroot\ec2-windows.zip")

$shell = new-object -com shell.application
$zip = $shell.NameSpace("c:\inetpub\wwwroot\ec2-windows.zip")
foreach($item in $zip.items())
{
$shell.Namespace("c:\inetpub\wwwroot\").copyhere($item)
}

New-Item -type directory -path "C:\dev\download\" -Force
New-Item -type directory -Path "C:\dev\" -Force


# Install MySQL Workbench
# https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.28-winx64.msi
Invoke-WebRequest https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.28-winx64.msi -OutFile C:\dev\download\mysql-workbench-community-8.0.28-winx64.msi
Start-Process -Wait -FilePath msiexec -ArgumentList /i, "C:\dev\download\mysql-workbench-community-8.0.28-winx64.msi", "ALLUSERS=1 /qn", "TARGETDIR=C:\dev\MySQLWorkbench", /quiet 


# Install Chrome
$LocalTempDir = $env:TEMP; 
$ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)



</powershell>
