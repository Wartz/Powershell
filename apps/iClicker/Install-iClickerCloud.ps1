# Powershell.exe -ExecutionPolicy ByPass -File Install-iClickerCloud.ps1 -Action "install" OR "uninstall"
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("install", "uninstall")]
    [string]$Action
)

$logpath = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\iClicker-Cloud-installer-verbose.log"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $scriptDir
$msiPath = Get-ChildItem ".\" -recurse | Where-Object {$_.extension -eq ".msi"} | ForEach-Object { $_.FullName }


function Install-iClickerCloud {
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiPath`"", "/qn", "/l*v `"$logpath`"" -Wait -NoNewWindow
}

function Uninstall-iClickerCloud {
    $msi_tagID = get-package -name "iClicker Cloud" | Select-Object -Property TagId
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/x `"$msi_tagID`"", "/qn", "/l*v `"$logpath`"" -Wait -NoNewWindow
}

switch ($Action) {
    "install" { 
        Install-iClickerCloud
     }
     "uninstall" {
        Uninstall-iClickerCloud
     }
}

# Add HKCU registry key to avoid the msi reconfig popup window on first launch
$keyPath = "HKCU:\Software\iClicker Cloud"
$valuePairs = @{
    "installed" = 1
    "optional_software_upste" = 1
}

# Create the key if it doesn't exist
if (!(Test-Path $keyPath)) {
    New-Item -Path $keyPath -Force | Out-Null
}

# Set the values as REG_DWORD
foreach ($valueName in $valuePairs.Keys) {
    New-ItemProperty -Path $keyPath -Name $valueName -Value $valuePairs[$valueName] -PropertyType DWord -Force
}

# Verify the key and values were created
if (Test-Path $keyPath) {
    foreach ($valueName in $valuePairs.Keys) {
        $value = Get-ItemPropertyValue -Path $keyPath -Name $valueName
        Write-Output "Value '$valueName' created successfully. Value: $value"
    }
} else {
    Write-Output "Failed to create the registry key."
}
