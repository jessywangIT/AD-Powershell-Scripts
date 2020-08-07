$users = Import-Csv -Path C:\Users\Jeswn\Desktop\inputfile.csv

$usersfound = foreach ($user In $users) {
    $first = $user.'First Name'.Trim()
    $last = $user.'Last Name'.Trim()
    if ($First -And $Last) {
        $account = Get-ADUser -Filter "GivenName -eq '$first' -And Surname -eq '$last' -And Description -ne 'IAM Managed'" -Properties EmailAddress
        if ($account -and $account -isnot [array]) {
            $account
        } else {
            Write-Host   "$first $last"
        }
    } else {
        Write-Host  'Missing Values for GivenName and\or Surname'
    }
}

$usersfound |
    Select-Object SAMAccountName |
    Export-Csv -Path C:\Users\Jeswn\Desktop\DisableUsernames.csv -NoTypeInformation