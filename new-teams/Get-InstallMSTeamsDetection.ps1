$MinVersion = "23285.3604.2469.4152"
$MSTeams = Get-ProvisionedAppPackage -Online |  Where-Object {$PSitem.DisplayName -like "MSTeams"}
if ($MSTeams.version -ge [version]$MinVersion ) { Write-Output "Installed" }
