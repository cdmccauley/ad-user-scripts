#Import-Csv -Path '.\last-login.csv' | sort -Property { $_."LastLogonTimeStamp" -as [datetime] } | Export-Csv ./sorted-csv.csv

# Import-Csv -Path '.\last-login.csv' | Where-Object {$_."LastLogonTimeStamp" -notlike "*1600*" -And $_."LastLogonTimeStamp" -notlike "*2019*" -And $_."LastLogonTimeStamp" -notlike "*2020*"} | sort -Property { $_."LastLogonTimeStamp" -as [datetime] } | Export-Csv ./sorted-csv.csv

Import-Csv -Path '..\last-login.csv' | 
Where-Object {$_."LastLogonTimeStamp" -as [datetime] -gt "12/31/1600 5:00:00 PM" -and $_."LastLogonTimeStamp" -as [datetime] -lt [datetime]::Now.AddYears(-1)} | 
Sort-Object -Property { $_."LastLogonTimeStamp" -as [datetime] } | 
Export-Csv ../sorted-csv.csv