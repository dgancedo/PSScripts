#
# Este script habilita el mailbox en la base con menor cantidad de usuarios
#
# USO: EnableUser.ps1 [username]
#
param ([Parameter(Mandatory=$true)][string]$username)

$dbnames = 'ExcDB?'

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

$LeastUsedDB = Get-Mailbox | Where {$_.database -like $dbnames} | Group-Object -Property:Database | Select-Object Name,Count  |Sort-Object Count | Select-Object -First 1 | Select-Object Name

$LeastUsedDBName = $LeastUsedDB.Name
Enable-Mailbox -Database $LeastUsedDBName -Identity $username
Write-Output "Mailbox for $username enabled on Database: $LeastUsedDBName" 