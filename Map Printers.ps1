#Variables
$portName107 = "192.168.0.107"
$portName108 = "192.168.0.108"
$portName109 = "192.168.0.109"

# Map temporary network drive
net use Z: \\RIVERSRV\DriverShare /user:hrrg\test.user H0rn3t!!!

#Remove Old Shared Printer Mappings
Remove-Printer -Name "RICOH MP C5503 PCL 6"
Remove-Printer -Name "RICOH MP C6003 PCL 6"
Remove-Printer -Name "Reception"

# Add Printer drivers
Z:\pnputil.exe /a \\riversrv\DriverShare\C307\disk1\oemsetup.inf
Z:\pnputil.exe /a \\riversrv\DriverShare\C5503\disk1\OEMSETUP.INF
Z:\pnputil.exe /a \\riversrv\DriverShare\C6003\disk1\OEMSETUP.INF

#Remove temporary network drive
net use Z: /delete

# Search for existing Printer Ports and create them if they do not exist, skip if they do.

$checkPortExists = Get-Printerport -Name $portname107 -ErrorAction SilentlyContinue
if (-not $checkPortExists) {
Add-PrinterPort -name $portName107 -PrinterHostAddress "192.168.0.107"
}
$checkPortExists = Get-Printerport -Name $portname108 -ErrorAction SilentlyContinue
if (-not $checkPortExists) {
Add-PrinterPort -name $portName108 -PrinterHostAddress "192.168.0.108"
}
$checkPortExists = Get-Printerport -Name $portname109 -ErrorAction SilentlyContinue
if (-not $checkPortExists) {
Add-PrinterPort -name $portName109 -PrinterHostAddress "192.168.0.109"
}


#Add the new Printer Mappings
Add-Printer -Name "RICOH MP C5503 PCL 6" -DriverName "RICOH MP C5503 PCL 6" -Port $portName107
Add-Printer -Name "RICOH MP C6003 PCL 6" -DriverName "RICOH MP C6003 PCL 6" -Port $portName108
Add-Printer -Name "Reception" -DriverName "RICOH MP C307 PCL 6" -Port $portName109
