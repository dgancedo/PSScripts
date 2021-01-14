# Requiere que el usuario que ejecuta tenga permisos de export mailbox
#
#     New-ManagementRoleAssignment –Role "Mailbox Import Export" –User "User"
#
# Luego de asignar los permisos es necesario que el usuario salga y e inicice sesion nuevamente


$serverpath="\\X.X.X.X\PST$"
$fwddomain="@domain.com"
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
foreach($line in Get-Content C:\Scripts\Userlist.txt) {
    
    Write-Output "Configurando forward para $line"
    Set-Mailbox -Identity $line -ForwardingSMTPAddress $line$fwddomain
    Write-Output "Configurando MoveMailboxRequest para $line"
    New-MailboxExportRequest -Mailbox $line -FilePath $serverpath\$line".pst" -Name $line
}

while(Get-MailboxExportRequest){
    write-output "Esperando que se completen los export..."
    Start-Sleep -Seconds 10
    foreach($move in Get-MailboxExportRequest -Status Completed){
        $name = $move.Name
        New-Item -Type File -Path $serverpath\$name".ok"
        Write-Output "Move de $name completado"
        Remove-MailboxExportRequest $name -Force -Confirm:$false
    }
    foreach($move in Get-MailboxExportRequest -Status CompletedWithWarning){
        $name = $move.Name
        New-Item -Type File -Path $serverpath\$name".okw"
        Write-Output "Move de $name completado con Warnings"
        Remove-MailboxExportRequest $name  -Force -Confirm:$false
    }
    foreach($move in Get-MailboxExportRequest -Status Failed){
        $name = $move.Name
        Write-Output "Fallo el move de $name Se remueve el forward"
        Set-Mailbox -Identity $name -ForwardingSMTPAddress $false
        Remove-MailboxExportRequest $name -Force -Confirm:$false
    }
}