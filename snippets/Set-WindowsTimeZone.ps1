# Get all timezone IDs
Get-TimeZone -ListAvailable

# Set time zone to EST with one liner

Set-TimeZone -Id $(Get-TimeZone -ListAvailable | Where-Object { $_.Id -eq 'Eastern Standard Time' } | Select-Object -ExpandProperty Id)
