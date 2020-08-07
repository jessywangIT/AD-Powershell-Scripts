$credential = Get-Credential
$userfn = Read-Host "Input user's first name"
$userln = Read-Host "Input user's last name"
Write-host "Is this user a 3rd Party?"
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-host "Yes"; $TEMP="TEMP"} 
       N {Write-Host "No"; $TEMP=""}   
     }
Write-host "Is this user a Warehouse Employee?"
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-host "Yes"; $path="ou=Warehouse,ou=Users,ou=US,ou=hm,dc=hm,dc=com"} 
       N {Write-Host "No"; $path="ou=Users,ou=US,ou=hm,dc=hm,dc=com"}   
     }  
$duplicatetarget = read-host "Please enter a user to copy"
$duplicateproperties = Get-ADUser -identity $duplicatetarget -properties Company, Department, Description, Office, Title
$password = ConvertTo-SecureString -String 'Hello123' -AsPlainText -Force
$name = $userln + ' ' + $userfn
$upntest = $TEMP + $userfn.substring(0,2) + $userln.substring(0,3)
$upn = $upntest.ToUpper() + "@hm.com"
$Samaccountname = $upntest.ToUpper()
$user = $(try {Get-ADUser $upntest} catch {$null})
$X = 1
$Y = 1
while ($user -ne $null) { 
    $upntest = $TEMP + $userfn.Substring(0, 1) + $userfn.Substring($X, $Y) + $userln.Substring(0,3)
    $upn = $upntest.ToUpper() + "@hm.com"
    $Samaccountname = $upntest.ToUpper()
    $X += 1
    $user = $(try {Get-ADUser $upntest} catch {$null}) 
}

if ($user -eq $null) {
    New-ADUser -Name $name -UserPrincipalName $upn -SamAccountName $Samaccountname -GivenName $userfn -Surname $userln -DisplayName $name -Description $duplicateproperties.Description -Office $duplicateproperties.Office -Credential $credential -AccountPassword $password -Title $duplicateproperties.Title -Department $duplicateproperties.Department -Company $duplicateproperties.Company -ChangePasswordAtLogon $true -Path $path -Enabled $true
    Get-AdPrincipalGroupMembership -Identity $duplicatetarget -Credential $credential | Where-Object -Property Name -Ne -Value 'Domain Users' | Add-AdGroupMember -Members $Samaccountname -Confirm:$false
    try {Get-ADUser -Identity $Samaccountname -Properties SamAccountName} catch{"The account was not created"}
}
