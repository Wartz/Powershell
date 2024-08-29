$fontfiles = Get-ChildItem .\fonts\* -File -Include '*.ttf', '*.otf'
$fontregpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
$windowsfontpath = "C:\Windows\Fonts"

# TODO: check file extensions to fille out registry key names: "Font Name (TrueType)" with value of "font_name.ttf"
#

# Copy fonts to the default Windows fonts directory
function Install-Fonts {
    Copy-Item $fontfiles $windowsfontpath
}


# TODO: Detect font type (truetype, OpenType, truetype collection)

# TODO: Register fonts in the registry
function Set-FontRegistration {
    foreach ($font in $fontfiles) {
        #Write-Output "Installing $font.Name to the registry"
        #New-ItemProperty -Path $fontregpath -Name $font -PropertyType "String" -Value "$font"
    }
}
