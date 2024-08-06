# List of packages to check (single line, comma-separated, in double quotes)
$packagesToCheck = "tidyverse, infer, broom, skimr, stats, statsr, openintro, resample, knitr"

function Check-Packages {
    # Base path for R installation
    $rBasePath = "C:\Program Files\R"

    # Get the latest R version installed
    $rVersion = Get-ChildItem -Path $rBasePath -Directory |
                Where-Object { $_.Name -match "R-\d+\.\d+\.\d+" } |
                Sort-Object -Property Name -Descending |
                Select-Object -First 1 -ExpandProperty Name

    if (-not $rVersion) {
        return $null
    }

    # Construct the path to the library
    $libraryPath = Join-Path -Path $rBasePath -ChildPath "$rVersion\library"

    if (-not (Test-Path $libraryPath)) {
        return $null
    }

    # Convert the string to an array
    $packageArray = $packagesToCheck -split ',' | ForEach-Object { $_.Trim() }

    # Check each package
    $installedPackages = @()
    foreach ($package in $packageArray) {
        $packagePath = Join-Path -Path $libraryPath -ChildPath $package
        if (Test-Path $packagePath) {
            $installedPackages += $package
        }
        else {
            return $null
        }
    }

    # If we've made it this far, all packages are present
    return $installedPackages
}

$result = Check-Packages

if ($result) {
    Write-Output "Installed packages: $($result -join ', ')"
}
else {}
