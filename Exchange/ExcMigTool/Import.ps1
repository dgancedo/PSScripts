#
# Sript que habilita las cuentas e importa desde PST
#
# 

$serverpath="\\X.X.X.X\PST$"
$dbnames = 'ExcDB?'
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

Get-ChildItem -Path $serverpath -Name *.ok? | ForEach-Object {

    $username = $_.Split('.')[0]
    $LeastUsedDB = Get-Mailbox | Where {$_.database -like $dbnames} | Group-Object -Property:Database | Select-Object Name,Count  |Sort-Object Count | Select-Object -First 1 | Select-Object Name
    $LeastUsedDBName = $LeastUsedDB.Name

    Enable-Mailbox -Database $LeastUsedDBName -Identity $username
    Write-Output "Mailbox for $username enabled on Database: $LeastUsedDBName" 

    New-MailboxImportRequest -Mailbox $username -FilePath $serverpath\$username".pst" -Name $username -TargetRootFolder /
}

while(Get-MailboxImportRequest){
    Start-Sleep -Seconds 10
    foreach($import in Get-MailboxImportRequest -Status Completed){
        $name = $import.name
        Rename-Item -Path $serverpath\$name".ok" -NewName $name".imported"
        Remove-MailboxImportRequest $name -Force -Confirm:$false
    }
    foreach($import in Get-MailboxImportRequest -Status CompletedWithWarning){
        $name = $import.name
        Rename-Item -Path $serverpath\$name".ok" -NewName $name".importedw"
        Remove-MailboxImportRequest $name -Force -Confirm:$false
    }
}


        
