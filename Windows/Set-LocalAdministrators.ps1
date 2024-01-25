
# Returns an NTAccount style username from a give SID string
function Convert-SIDtoUsername {
    param (
        [string]$SID
    )
    try {
        $username = (New-Object System.Security.Principal.SecurityIdentifier $SID).Translate([System.Security.Principal.NTAccount]).Value
    } catch {
        Write-Error "Error Converting SD to Username: $_"
    }

    return $username
}

#Filter the User Profiles Service log for event ID 2
function Get-EventLogTimeCreatedUserID {
    param (
        $LogName
    )
    
    $EventFilter = @{logname=$LogName;ID=2}

    $events = Get-WinEvent -FilterHashTable $EventFilter |
    Select-Object -Property TimeCreated, UserID, @{N='Detailed Message'; E={$_.Message}} |
    Sort-Object -Property TimeCreated
    
    return $events
}

# For testing - writes out UserID and event TimeCreated
function Format-EventInfo {
    param (
        $LogName
    )
    $events = Get-EventLogTimeCreatedUserID -LogName $LogName

    # Show information for each event
    foreach ($event in $events) {
        $timeCreated = $event.TimeCreated
        $userSID = $event.UserId

        Write-Output "Time Created: $timeCreated"
        Write-Output "SID: $userSID"
    }
}

# Check for a username string in Local Administrators group
function Search-UserInAdministratorsGroup {
    param (
        [string]$username
    )

    # Check if the user is a member of the local administrators group
    $isAdmin = net localgroup administrators | Select-String -Pattern $username -Quiet
    return $isAdmin
}

# Add a username to the local administrators group
function Add-UsersToLocalAdministrators {
    param (
        [string[]]$usernames
    )

    # Add each username to the local administrators group if not already a member
    foreach ($username in $usernames) {
        if (-not (Search-UserInAdministratorsGroup -username $username)) {
            net localgroup administrators $username /add
            Write-Output "Added $username to the local administrators group."
        } else {
            Write-Output "$username is already a member of the local administrators group."
        }
    }
}

$LogName = "Microsoft-Windows-User Profile Service/Operational"

#Get-EventLogTimeCreatedUserID -LogName $LogName
#Format-EventInfo -LogName $LogName
Convert-SIDtoUsername -SID "S-1-12-1-2292503744-1204256175-2738463129-2219009640"
