<#
.SYNOPSIS
Checks if the SecurityHealthSystray process is running.

.DESCRIPTION
This function checks if the SecurityHealthSystray process is running on the system. If the process is found, the script exits with a status of 0 (success). If the process is not found, the script exits with a status of 1 (failure).

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
        exit 0
    } else {
        exit 1
    }
}

Check-Process
