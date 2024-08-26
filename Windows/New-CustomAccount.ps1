<#
.SYNOPSIS
Creates or modifies a local Windows account with specific settings.

.DESCRIPTION
This script creates a new local Windows account or modifies an existing one. 
The account is set to never expire, added to the local Administrators group, 
and its password is set to never expire.

.PARAMETER Username
The username for the account to be created or modified.

.PARAMETER Password
The password to be set for the account.

.EXAMPLE
.\New-AdminAccount.ps1 -Username "Eclassroom" -Password "Ithaca"
Creates or modifies an account named "Eclassroom" with the password "Ithaca".

.NOTES
File Name      : New-AdminAccount.ps1
Prerequisite   : PowerShell V3 or higher
Copyright      : (c) 2024 Joe Schlimmer, Ithaca College
License        : MIT License
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$true)]
    [string]$Password
)

function New-CustomAccount {
    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force

    if (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue) {
        Set-CustomPassword
    } else {
        New-LocalUser -Name $Username -Password $securePassword -PasswordNeverExpires -UserMayNotChangePassword -AccountNeverExpires
        Add-LocalGroupMember -Group "Administrators" -Member $Username
        Write-Output "Account '$Username' created successfully and added to the Administrators group."
    }
}

function Set-CustomPassword {
    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force

    Set-LocalUser -Name $Username -Password $securePassword -PasswordNeverExpires $true
    Write-Output "Password for account '$Username' has been reset and set to never expire."
}

# Main execution
New-CustomAccount
