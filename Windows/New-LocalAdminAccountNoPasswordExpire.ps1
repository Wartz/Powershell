<#
.SYNOPSIS
    Manages a local Windows user account named "Admin", creating it if it doesn't exist and setting its password to never expire.

.DESCRIPTION
    This PowerShell script provides functions to manage the "Admin" user account on a local Windows machine. 
    It ensures the account exists and sets its password to never expire.

    Pre-requisites:

    Run with administrative privileges.
    Ensure execution policy allows running scripts (Set-ExecutionPolicy Unrestricted).

.PARAMETER username
    Specifies the username for the local user account. Default is "Admin".

.PARAMETER password
    Specifies the password for the local user account. Default is a hashed password.

.PARAMETER fullname
    Specifies the full name for the local user account. Default is "Admin".

.PARAMETER description
    Specifies the description for the local user account. Default is "Admin".

.EXAMPLE
    .\New-LocalAdminAccountNoPasswordExpire.ps1 -username "Admin" -password "YourPassword" -fullname "Administrator" -description "System Administrator"
    # Creates or updates the "Admin" user account with the provided details.

.EXAMPLE
    .\New-LocalAdminAccountNoPasswordExpire.ps1
    # Uses default parameters to manage the "Admin" user account.

.NOTES
    Author: Joe Schlimmer
    Date: 2024-02-07
    Version: 1.0
    PowerShell Version: 5.1
    Changelog: First edition
#>

param(
    [string]$username = "Admin",
    $password = $(Read-Host "Enter Password that will be Set" -AsSecureString),
    $fullname = "Admin",
    $description = "Admin"
)


function Test-AdminPrivilege {
    try {
        $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        $isElevated = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        if ($isElevated) {
            Write-Output "Script is running with elevated privileges (as Administrator)."
        } else {
            Write-Output "Script is NOT running with elevated privileges."
            exit
        }
    } catch {
        Write-Output "Error occurred while checking admin privileges: $_"
    }
}


Function Assert-AdminLocalUser {
    [CmdletBinding()]
    param(
        [string]$username #localuser name
    )
    $checkForUser = (Get-LocalUser).Name -Contains $username
    $result = $false  #default return value
    If ($checkForUser) {
        #if this has value, it will always be true
        $result = "$username Exists " #changes return value
    }

    return $result
}

Function New-AdminLocalUser {
    $params = @{
        Name        = $username
        Password    = ConvertTo-SecureString -String $password
        FullName    = $fullname
        Description = $description
        PasswordNeverExpires = $true
    }
    try {
        New-LocalUser @params -ErrorAction Stop
        Write-Output "User $username created successfully."
    } catch {
        Write-Error "Error: $_"
    }
}

Function Set-AdminLocalUserNeverExpire {
    if (! (Assert-AdminLocalUser -username $username)) {
        New-AdminLocalUser
    }
    else {
        Set-LocalUser -Name $username -PasswordNeverExpires:$true
    }
}

Test-AdminPrivilege
Set-AdminLocalUserNeverExpire
