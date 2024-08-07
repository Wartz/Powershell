# Script to copy iClicker Cloud registry key from HKLM to HKCU for the current user

# Get the SID of the current user
$currentUserSID = (Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.LocalPath -eq $env:USERPROFILE }).SID

# Define the source and destination registry paths
$sourceKey = "HKLM:\SOFTWARE\iClicker Cloud"
$destKey = "Registry::HKEY_USERS\$currentUserSID\Software\iClicker Cloud"

# Check if the source key exists
if (Test-Path $sourceKey) {
    # Create the destination key if it doesn't exist
    if (!(Test-Path $destKey)) {
        New-Item -Path $destKey -Force | Out-Null
    }

    # Copy the registry values
    $values = Get-ItemProperty -Path $sourceKey
    foreach ($value in $values.PSObject.Properties) {
        if ($value.Name -notin @('PSPath', 'PSParentPath', 'PSChildName', 'PSDrive', 'PSProvider')) {
            Set-ItemProperty -Path $destKey -Name $value.Name -Value $value.Value
        }
    }

    Write-Output "Registry key copied successfully from HKLM to HKCU for the current user."
}
else {
    Write-Output "Source registry key not found in HKLM. No action taken."
}
