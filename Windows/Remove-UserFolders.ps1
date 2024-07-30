# Run as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
}

# Define the path to check
$usersPath = "C:\Users"

# Define the list of default Windows folders that should not be deleted
$defaultFolders = @("Public", "Default", "Default User", "All Users", "desktop.ini", "Temp")

# Get all user folders
$userFolders = Get-ChildItem -Path $usersPath -Directory

# Loop through each folder
foreach ($folder in $userFolders) {
    # Check if the folder is not in the default list
    if ($defaultFolders -notcontains $folder.Name) {
        try {
            # Attempt to delete the folder and its contents
            Remove-Item $folder.FullName -Recurse -Force -ErrorAction Stop
            Write-Host "Successfully deleted folder: $($folder.FullName)" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to delete folder: $($folder.FullName)" -ForegroundColor Red
            Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "Script execution completed." -ForegroundColor Cyan
