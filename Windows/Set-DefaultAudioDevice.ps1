<#
Use 
   Get-AudioDevice -List
to learn about available devices on your system.
Then set the two variables below with the start of their names.

## Swiped from https://superuser.com/a/1624464
## Joe Schlimmer
## 2023-10-09
#>

$device1 = "PHILIPS"
$device2 = "Speakers"

$Audio = Get-AudioDevice -playback
Write-Output "Audio device was " $Audio.Name
Write-Output "Audio device now set to " 

if ($Audio.Name.StartsWith($device1)) {
   (Get-AudioDevice -list | Where-Object Name -like ("$device2*") | Set-AudioDevice).Name
}  Else {
   (Get-AudioDevice -list | Where-Object Name -like ("$device1*") | Set-AudioDevice).Name
}
