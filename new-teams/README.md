# Microsoft Teams (New) bulk installer

<https://www.microsoft.com/en-us/microsoft-teams/download-app>

<https://learn.microsoft.com/en-us/microsoftteams/new-teams-bulk-install-client>

Use teamsbootstrapper.exe to download the latest teams MSIX, or target a manual (offline) install with a pre-downloaded msix.

`.\teamsbootstrapper.exe -p -o .\path\to\msix`

## Windows 10 AVD errors

### 0x80004004 Error - may need the windows store to be installed

```
.\teamsbootstrapper.exe -p
{
"success": false,
"errorCode": "0x80004004"
}
```

### Reinstall MS Store

`Get-AppXPackage *WindowsStore* -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}`

Reboot

### Remove teams registry keys

`Remove-ItemProperty -Path "HKLM:Software\Wow6432Node\Microsoft\Office\Teams" -Name "maglevInstallationSource"`

`Remove-ItemProperty -Path "HKLM:Software\Wow6432Node\Microsoft\Office\Teams" -Name "maglevExitCode"`

## Bulk installer powershell script

<https://github.com/suazione/CodeDump/blob/main/Install-MSTeams.ps1>

`.\Install-MSTeams.ps1 -ForceInstall -SetRunOnce`

Executes the script and attempts to force the installation by uninstalling MSTeams before attepmting an installation.
SetRunOnce will add a RunOnce registry entry and scheduled task to speed up the installation of MSTeams.
These are the recommended parameters for installation.


Full Install-MSTeams.ps1 install command for Intune/SCCM

`PowerShell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File ".\Install-MSTeams.ps1" -ForceInstall -SetRunOnce -DownloadExe -LogFile "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Install-MSTeams.log"`

If necessary, we can also run it with the 64 bit PS exe
​​​​​​​
`%windir%\Sysnative\WindowsPowerShell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File ".\Install-MSTeams.ps1" -ForceInstall -SetRunOnce -DownloadExe -LogFile "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Install-MSTeams.log"`

## Uninstall with bulk script
`PowerShell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File ".\Install-MSTeams.ps1" -Uninstall -DownloadExe -LogFile "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Install-MSTeams.log"`

`%windir%\Sysnative\WindowsPowerShell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File ".\Install-MSTeams.ps1" -Uninstall -DownloadExe -LogFile "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Install-MSTeams.log"`

## Detection

Detection script example 2:

```PowerShell
$MinVersion = "23285.3604.2469.4152"
$MSTeams = Get-ProvisionedAppPackage -Online |  Where-Object {$PSitem.DisplayName -like "MSTeams"}
if ($MSTeams.version -ge [version]$MinVersion ) { Write-Output "Installed" }
```
