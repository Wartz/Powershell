function Get-LicenseStatus {
    $LicenseStatus = $(Get-WmiObject -Query 'SELECT LicenseStatus,Name FROM SoftwareLicensingProduct WHERE Name LIKE "%Windows%" AND LicenseStatus = 1')
    return $LicenseStatus
}


function Install-OA3xOriginalProductKey {
    if ( ! (Test-Activation) ) {
        $(Get-WmiObject SoftwareLicensingService).OA3xOriginalProductKey | ForEach-Object{ if ( $null -ne $_ ) { Write-Host "Installing"$_;changepk.exe /Productkey $_ } else { Write-Host "No key present" } }
    }
}

function Test-Activation {
    $activationStatus = $(Get-LicenseStatus)
    if ( $activationStatus.LicenseStatus -ne 1 ) {
        Write-Output "Needs activation"
        return $false
    }
    else {
        Write-Output "$($activationStatus.Name) is activated with a digital license"
        return $true
    }
}


Test-Activation
