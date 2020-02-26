Import-Csv -Path '..\sorted-csv.csv' | 
Write-Host ("{0}" -f (Select-Object -ExpandProperty "samaccountname") )

# Select-Object -ExpandProperty "samaccountname"