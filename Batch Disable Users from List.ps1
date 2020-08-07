$credential = Get-Credential
$date = Get-Date -Format "MM/dd/yyy"
$OUpath = 'ou=Disabled,ou=Users,ou=US,ou=hm,dc=hm,dc=com'

#Below is where you will input the file path to your CSV
$file = Import-Csv -Path C:\Users\Jeswn\Desktop\DisableUsernames.csv
ForEach ($user in $file)
    {   
    $Samaccountname = $user.SAMAccountName.trim()
    $adUser = Get-ADUser -Identity $Samaccountname
    $OldDescription = Get-ADUser -Identity $Samaccountname -Properties Description | Select-Object -ExpandProperty Description
    $NewDescription = 'Disabled by ' + $env:USERNAME + ' on ' + $date + " - " + $OldDescription
    Get-AdPrincipalGroupMembership -Identity $Samaccountname -Credential $credential | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $Samaccountname -Confirm:$false
    Set-ADUser $Samaccountname -Description $NewDescription -Credential $credential
    Disable-ADAccount -Identity $Samaccountname -Credential $credential
    Move-ADObject -Identity $adUser -Credential $credential -TargetPath $OUpath
    }