$credential = Get-Credential
$Samaccountname = read-host "Please enter Username to disable"
$adUser = Get-ADUser -Identity $Samaccountname
$date = Get-Date -Format "MM/dd/yyy"
$OUpath = 'ou=Disabled,ou=Users,ou=US,ou=hm,dc=hm,dc=com'
$OldDescription = Get-ADUser -Identity $Samaccountname -Properties Description | Select-Object -ExpandProperty Description
$NewDescription = 'Disabled by ' + $env:USERNAME + ' on ' + $date + " - " + $OldDescription
Get-AdPrincipalGroupMembership -Identity $Samaccountname -Credential $credential | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $Samaccountname -Confirm:$false
Set-ADUser $Samaccountname -Description $NewDescription -Credential $credential
Disable-ADAccount -Identity $Samaccountname -Credential $credential
Move-ADObject -Identity $adUser -Credential $credential -TargetPath $OUpath
Get-ADUser -Identity $Samaccountname -Properties Description, DistinguishedName, Enabled
