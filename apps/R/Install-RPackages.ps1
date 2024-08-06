<#
.SYNOPSIS
Installs a set of packages for the R programming lanaguage
.DESCRIPTION
Installs a set of packages for the R programming lanaguage
.PARAMETER Packages
Takes a list of 1 or more double quoted package names and install them in order.
.EXAMPLE
Install-RPackages.ps1 -Packages "tidyverse, infer, broom, skimr, stats, statsr, openintro, resample, knitr"
.NOTES
Must be run with admin rights to write to the ..\lib directory in Program Files
.LINK
Related links or references.
#>
param(
    [Parameter(Mandatory=$true)]
    [string[]]$Packages
)
# Base path for R installation
$rBasePath = "C:\Program Files\R"
# Get the latest R version installed
$rVersion = Get-ChildItem -Path $rBasePath -Directory |
            Where-Object { $_.Name -match "R-\d+\.\d+\.\d+" } |
            Sort-Object -Property Name -Descending |
            Select-Object -First 1 -ExpandProperty Name
if (-not $rVersion) {
    Write-Error "No R installation found in $rBasePath. Please check the installation path."
    exit 1
}
# Construct the path to Rscript.exe using the found version
$rscriptPath = Join-Path -Path $rBasePath -ChildPath "$rVersion\bin\Rscript.exe"
# Check if Rscript.exe exists
if (-not (Test-Path $rscriptPath)) {
    Write-Error "Rscript.exe not found at $rscriptPath. Please check the R installation."
    exit 1
}
# Define the system-wide library path
$systemLibPath = Join-Path -Path $rBasePath -ChildPath "$rVersion\library"
Write-Debug "Using R version: $rVersion"
Write-Debug "Rscript path: $rscriptPath"
Write-Debug "System-wide library path: $systemLibPath"
foreach ($package in $Packages) {
    Write-Output "Installing package: $package"
   
    # Use single quotes for R code to avoid escaping issues
    $rCode = "-e `"install.packages(c('$package'), repos='https://cran.rstudio.com/')`""
    # Call Rscript.exe to execute the R code
    $process = Start-Process -FilePath $rscriptPath -ArgumentList "$rCode" -NoNewWindow -PassThru -Wait
    if ($process.ExitCode -eq 0) {
        Write-Output "Package $package installed or already present in system-wide library."
    } else {
        Write-Error "Failed to install package $package in system-wide library."
    }
}
Write-Output "All specified packages have been processed."
