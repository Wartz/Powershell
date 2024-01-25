<#
.SYNOPSIS
Checks if the SecurityHealthSystray process is running.

.DESCRIPTION
This function checks if the SecurityHealthSystray process is running on the system. If the process is found, it outputs a message indicating that the process is running. If the process is not found, it outputs a message indicating that the process is not running.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Check-Process
Checks if the SecurityHealthSystray process is running.

.NOTES
Author: Joe Schlimmer
Date: 2024-01-25
Version: 1.0
#>

function Check-Process {
    $process = Get-Process -Name SecurityHealthSystray -ErrorAction SilentlyContinue
    if ($process) {
        Write-Output "SecurityHealthSystray process is running."
    } else {
        Write-Output "SecurityHealthSystray process is not running."
    }
}

Check-Process
