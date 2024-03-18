$uncPath = \\path\to\server\reboot\

Get-WinEvent -FilterHashtable @{ LogName = 'System'; Id = 41, 1074, 6006, 6605, 6008; } | Format-List Id, LevelDisplayName, TimeCreated, Message | out-file "$uncPath\$(get-date -f yyyy-MM-dd)-$((Get-CimInstance -ClassName Win32_ComputerSystem).Name)-shutdown-logs.csv"
