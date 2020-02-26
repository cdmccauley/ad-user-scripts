# powershell.exe -ExecutionPolicy Bypass -File .\<filename>

#[DateTime]::FromFileTimeutc($timestamp)

#https://gallery.technet.microsoft.com/scriptcenter/Powershell-script-to-398c5aab

# Get-ADUser -Filter * -SearchBase "dc=INFOTECH,dc=LOCAL" -ResultPageSize 0 -Prop CN,samaccountname,lastLogonTimestamp | Select CN,samaccountname,@{n="lastLogonDate";e={[datetime]::FromFileTime  
#     ($_.lastLogonTimestamp)}} | Export-CSV -NoType \\infotech.local\Share\Instructors$\operator\Desktop\last-login.csv

# Get-ADUser -Filter * -SearchBase "dc=INFOTECH,dc=LOCAL" -ResultPageSize 0 -Prop CN,samaccountname,lastLogonTimestamp | 
# Select CN,samaccountname,@{Name="LastLogonTimeStamp";Expression={([datetime]::FromFileTime($_.LastLogonTimeStamp))}} | 
# Export-CSV -NoType \\infotech.local\Share\Instructors$\operator\Desktop\last-login.csv

# untested change from Select to Select-Object, want to change and test output dir too
Get-ADUser -Filter * -SearchBase "dc=INFOTECH,dc=LOCAL" -ResultPageSize 0 -Prop CN,samaccountname,lastLogonTimestamp | 
Select-Object CN,samaccountname,@{Name="LastLogonTimeStamp";Expression={([datetime]::FromFileTime($_.LastLogonTimeStamp))}} | 
Export-CSV -NoType \\infotech.local\Share\Instructors$\operator\Desktop\last-login.csv

