$ProgramName = ""
$ProgramCode = Get-WmiObject -class Win32_Product | ? {$_.Name -eq "$ProgramName"}
$ProgramCode.IdentifyingNumber
