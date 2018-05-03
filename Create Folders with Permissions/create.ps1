#Author: Diego S. Gancedo <dgancedo@gmail.com>
#
#


$FolderName = ""
$Confirm = "N"

$GroupContainer = "OU=Groups,OU=yourOU,DC=YourDomain,DC=Someting" #Adaptar segun correponda con la estructura de AD
$GroupPrefix = "FSP" #Custom group prefix for fileserver permisions 

$Server = Read-Host -Prompt 'Enter your server name'
$Share = Read-Host -prompt 'Enter the share name'

Write-Output " "
Write-Output "The Path for creating the folders is: \\$Server\$Share"
$Confirm = Read-Host -prompt "This is correct? Y/N"

if (($Confirm -eq 'Y') -or ($Confirm -eq 'y')) {
    while ($FolderName -ne 'X' -or $FolderName -ne 'x'){ 
        Write-Output " "
        $FolderName = Read-Host -Prompt "Enter the folder name - or 'X' to end"
        if ($FolderName -eq 'X' -or $FolderName -eq 'x') {break}
        $GroupName = Read-Host -Prompt "Enter the Group Base Name"

        new-item -ItemType Directory -Path \\$Server\$Share\"$FolderName"
        New-ADGroup -Name "$GroupPrefix-$Server-RW-$GroupName" -GroupCategory Security -GroupScope Global -Path $GroupContainer
        New-ADGroup -Name "$GroupPrefix-$Server-RO-$GroupName" -GroupCategory Security -GroupScope Global -Path $GroupContainer

        $acl = Get-Acl -Path "\\$Server\$Share\$FolderName"
        $acl.SetAccessRuleProtection($true,$true) #Remove inheritance
        Set-Acl -Path "\\$Server\$Share\$FolderName" -AclObject $acl
        $acl = Get-Acl -Path "\\$Server\$Share\$FolderName"
        $acl.Access |where {$_.IdentityReference -eq "Builtin\Users"} |%{$acl.RemoveAccessRule($_)} #Remove Builtin\users
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("$GroupPrefix-$BaseServer-RO-$GroupName","ReadAndExecute","Allow")
        $acl.SetAccessRule($rule)
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("$GroupPrefix-$BaseServer-RW-$GroupName","Modify","Allow")
        $acl.SetAccessRule($rule)
        Set-Acl -Path "\\$Server\$Share\$FolderName" -AclObject $acl


        

    }
}

