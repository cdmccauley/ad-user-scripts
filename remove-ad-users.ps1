# ===
# instructions:
# powershell.exe -ExecutionPolicy Bypass -File <filename>
# ===

# ---
# imports
# ---
Import-Module ActiveDirectory

# ---
# declarations
# ---
$DaysInactive = 0
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))
$KeepAccounts = @('MSSQL', 'default', 'dhcpdns', 'test1', 'tv', 'sccmadmin', '_default', 'sbchristensen', 'mccaulcd', 'brummett', 'bigdaddy', 'Bitterjr', 'Khadley', 'Robbie', 'henderst', 'thesteve', 'hepleraj')

# ---
# get users that have been inactive for $DaysInactive
# ---
# next line targets all accounts excluding those in the $KeepAccounts array
# $Users = Get-ADUser -Filter { LastLogonDate -lt $InactiveDate -and Enabled -eq $true -and SamAccountName -notlike "*svc*" } -Properties LastLogonDate | Where-Object SamAccountName -notin $KeepAccounts | Select-Object @{ Name="Username"; Expression={$_.SamAccountName} }, Name, LastLogonDate, DistinguishedName

# next line targets all accounts in OU=DEAD excluding those in the $KeepAccounts array
# $Users = Get-ADUser -SearchBase "OU=DEAD,DC=INFOTECH,DC=LOCAL" -Filter { LastLogonDate -lt $InactiveDate -and Enabled -eq $true -and SamAccountName -notlike "*svc*" } -Properties LastLogonDate | Where-Object SamAccountName -notin $KeepAccounts | Select-Object @{ Name="Username"; Expression={$_.SamAccountName} }, Name, LastLogonDate, DistinguishedName

# next line targets all accounts in OU=DEAD that have never logged in excluding those in the $KeepAccounts array
$Users = Get-ADUser -SearchBase "OU=DEAD,DC=INFOTECH,DC=LOCAL"  -Filter { LastLogonDate -notlike "*" -and Enabled -eq $true } -Properties LastLogonDate | Where-Object SamAccountName -notin $KeepAccounts  | Select-Object @{ Name="Username"; Expression={$_.SamAccountName} }, Name, LastLogonDate, DistinguishedName

# ---
# report
# ---
# $Users | Export-Csv \\infotech.local\Share\Instructors$\operator\Desktop\remove-ad-users.csv -NoTypeInformation

# ---
# remove profile and profiles folders/files
# ---
ForEach ($Item in $Users){
  # remove user account
  Remove-ADUser -Identity $Item.DistinguishedName -Confirm:$false
  # take ownership of profile folders/files
  takeown  /f "D:\Profiles$\$($Item.Username)" /a /r /d y /skipsl
  cacls "D:\Profiles$\$($Item.Username)" /e /t /g administrators:f
  # remove profile folders/filse
  Remove-Item -Recurse -Force "D:\Profiles$\$($Item.Username)"
  # signal user deletion
  Write-Output "$($Item.Username) - Deleted"
}