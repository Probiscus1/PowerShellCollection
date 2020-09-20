$RemoteServer = Read-Host -Prompt "Enter the hostname of the remote server"
Do {

echo "Remote Server's time" >> C:\temp\Time.log
Invoke-Command -ComputerName $RemoteServer -ScriptBlock {Get-Date -Format  hh:mm:ss}  >> C:\temp\Time.log
echo "My Time"  >> C:\temp\Time.log
Get-Date -Format  hh:mm:ss >> C:\temp\Time.log

sleep 30

}

while ($true)