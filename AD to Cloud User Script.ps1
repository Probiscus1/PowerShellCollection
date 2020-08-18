$username = Read-Host -Prompt 'Enter the Username of the User you wish to move within AD'
$UPN = Read-Host -Prompt 'Enter the UPN of the User you wish to restore'

echo 'Moving $username'
get-aduser $Username | move-adobject -targetpath "OU=Users - Non-365,OU=SBSUsers,OU=Users,OU=MyBusiness,DC=hrrg,DC=local"
echo 'Connecting to MSOL Service'
echo 'Running AAD Connector Delta Sync'
Start-ADSyncSyncCycle -PolicyType Delta
echo 'Waiting 60 seconds for Delta Sync to complete...'
Start-Sleep -s 30
echo '30 seconds remaining...'
Start-Sleep -s 20
echo '10 seconds remaining...'
Start-Sleep -s 10
echo 'Wait Complete'
echo 'Restoring $UPN'
Restore-MsolUser -UserPrincipalName $UPN
echo 'Restore command completed.'
echo 'Setting ImmutableID to $null'
Set-MSOLUser -UserPrincipalName $UPN -ImmutableID "$null"
echo 'ImmutableID set'
pause
