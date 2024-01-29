<#
.SYNOPSIS
Removes an MSI application using the provided product code.

.DESCRIPTION
This script removes an MSI application using the provided product code. It detects the product name and version based on the product code and then proceeds with uninstallation.

.PARAMETER ProductCode
Specifies the product code of the MSI application to uninstall. If not provided, a prompt will ask the user to input the product code string.

.EXAMPLE
.\Remove-AppWithProductCode.ps1 -ProductCode "{9372B279-7E42-4A4B-90B0-D43411B770CD}"
Removes the MSI application with the specified product code.

.NOTES
Author: Joe Schlimmer
Date: January 29, 2024
#>

param (
    [string]$ProductCode = "00000000-0000-0000-0000-000000000000"
)

if ($ProductCode -eq "00000000-0000-0000-0000-000000000000") {
    $ProductCode = Read-Host "Enter the product code of the MSI application to uninstall"
}

# Get product information based on the product code
$productInfo = Get-WmiObject -Class Win32_Product | Where-Object { $_.IdentifyingNumber -eq $ProductCode }

if ($productInfo) {
    $ProductName = $productInfo.Name
    $ProductVersion = $productInfo.Version
    
    Write-Output "Detected product name: $ProductName"
    Write-Output "Detected product version: $ProductVersion"

    # Uninstall the product
    $uninstallResult = (Start-Process msiexec.exe -ArgumentList "/x $ProductCode /qn" -Wait -PassThru).ExitCode
    if ($uninstallResult -eq 0) {
        Write-Host "Uninstallation of $ProductName version $ProductVersion successful."
    } else {
        Write-Host "Uninstallation of $ProductName version $ProductVersion failed. Exit code: $uninstallResult"
    }
} else {
    Write-Host "Product with code $ProductCode is not installed."
}
