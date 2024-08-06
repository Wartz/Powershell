# Base path for R installation
$rBasePath = "C:\Program Files\R"
# List of packages to check (single line, comma-separated, in double quotes)
$packagesToCheck = "tidyverse, infer, broom, skimr, stats, statsr, openintro, resample, knitr"

# Get the latest R version installed
$rVersion = Get-ChildItem -Path $rBasePath -Directory |
            Where-Object { $_.Name -match "R-\d+\.\d+\.\d+" } |
            Sort-Object -Property Name -Descending |
            Select-Object -First 1 -ExpandProperty Name

if (-not $rVersion) {
    Write-Error "No R installation found in $rBasePath."
    exit 1
}

# Construct the path to the library
$libraryPath = Join-Path -Path $rBasePath -ChildPath "$rVersion\library"

if (-not (Test-Path $libraryPath)) {
    Write-Error "Library path not found at $libraryPath."
    exit 1
}


# Convert the string to an array
$packageArray = $packagesToCheck -split ',' | ForEach-Object { $_.Trim() }

# Check each package
foreach ($package in $packageArray) {
    $packagePath = Join-Path -Path $libraryPath -ChildPath $package
    if (-not (Test-Path $packagePath)) {
        Write-Output "Package not found: $package"
        exit 1  # Exit with non-zero code if any package is missing
    }
}

# If we've made it this far, all packages are present
Write-Output "All required packages are installed."
exit 0  # Exit with zero code if all packages are present
