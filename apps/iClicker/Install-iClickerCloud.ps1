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

function Set-IClickerCloudRegistry {
    [CmdletBinding()]
    param(
        [string]$KeyPath = "HKCU:\Software\iClicker Cloud",
        [hashtable]$ValuePairs = @{
            "installed" = 1
            "optional_software_update" = 1
        }
    )

    process {
        try {
            # Create the key if it doesn't exist
            if (!(Test-Path $KeyPath)) {
                New-Item -Path $KeyPath -Force | Out-Null
            }

            # Set the values as REG_DWORD
            foreach ($valueName in $ValuePairs.Keys) {
                New-ItemProperty -Path $KeyPath -Name $valueName -Value $ValuePairs[$valueName] -PropertyType DWord -Force | Out-Null
            }

            # Verify the key and values were created
            if (Test-Path $KeyPath) {
                foreach ($valueName in $ValuePairs.Keys) {
                    $value = Get-ItemPropertyValue -Path $KeyPath -Name $valueName
                    Write-Output "Value '$valueName' created successfully. Value: $value"
                }
            } else {
                throw "Failed to create the registry key."
            }
        }
        catch {
            Write-Error "An error occurred: $_"
        }
    }
}

switch ($Action) {
    "install" { 
        Install-iClickerCloud
        Set-IClickerCloudRegistry
     }
     "uninstall" {
        Uninstall-iClickerCloud
     }
}
