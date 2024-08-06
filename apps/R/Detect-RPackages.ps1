# List of packages to check (single line, comma-separated, in double quotes)
$packagesToCheck = "tidyverse, infer, broom, skimr, stats, statsr, openintro, resample, knitr"

try {
    # Base path for R installation
    $rBasePath = "C:\Program Files\R"

    # Get the latest R version installed
    $rVersion = Get-ChildItem -Path $rBasePath -Directory |
                Where-Object { $_.Name -match "R-\d+\.\d+\.\d+" } |
                Sort-Object -Property Name -Descending |
                Select-Object -First 1 -ExpandProperty Name

    if (-not $rVersion) {
        throw "No R installation found in $rBasePath."
    }

    # Construct the path to the library
    $libraryPath = Join-Path -Path $rBasePath -ChildPath "$rVersion\library"

    if (-not (Test-Path $libraryPath)) {
        throw "Library path not found at $libraryPath."
    }

    # Convert the string to an array
    $packageArray = $packagesToCheck -split ',' | ForEach-Object { $_.Trim() }

    # Check each package
    foreach ($package in $packageArray) {
        $packagePath = Join-Path -Path $libraryPath -ChildPath $package
        if (-not (Test-Path $packagePath)) {
            throw "Package not found: $package"
        }
    }

    # If we've made it this far, all packages are present
    Write-Output "Installed"
    exit 0  # Exit with zero code if all packages are present
}
catch {
    Write-Output $_.Exception.Message
    exit 1  # Exit with non-zero code if any error occurs
}
