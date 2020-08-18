$DaysForward = 7
$DaysBack = -14
$Exchange = 
$From = 
$To = 
$DestinationFile = "C:\temp\Password Expiry.txt"
$StartDate1 = Get-date
$EndDate1 = $StartDate1.AddDays($DaysForward)
$StartDate2 = $StartDate1.AddDays($DaysBack)
$EndDate2 = $StartDate1

# Written by Nathan Reed from saberVox Cloud Solutions (1300 788 515).

# Find AD passwords that are expiring within 7 days then output to $DestinationFile.
echo  "Passwords expiring within 7 days:" > $DestinationFile
Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Sort-Object ExpiryDate | Where-Object {$_.ExpiryDate -ge $StartDate1 -and $_.ExpiryDate -lt $EndDate1 } >> $DestinationFile

# Find AD passwords that have expired within the last 14 days and have not been changed then output to $DestinationFile.
echo "Expired passwords that have not been changed within the past 14 days:" >> $DestinationFile
Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Sort-Object ExpiryDate | Where-Object {$_.ExpiryDate -ge $StartDate2 -and $_.ExpiryDate -lt $EndDate2 } >> $DestinationFile

# Send $DestinationFile to $To via email.
Send-MailMessage –From $From –To $To –Subject "Password Expiries" –Body “Attached is a list of Users with AD passwords expiring this week and expired passwords that have not been changed within the past 14 days." -Attachment $DestinationFile -SmtpServer $Exchange -Port 25