$credential = Get-Credential
$Samaccountname = read-host "Please enter the new username"
$copyaccount = Read-Host "Please enter username to copy group membership from"

Get-AdPrincipalGroupMembership -Identity $copyaccount -Credential $credential | Where-Object -Property Name -Ne -Value 'Domain Users' | Add-AdGroupMember -Members $Samaccountname -Confirm:$false