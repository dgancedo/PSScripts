$Computers = Get-ADComputer -Filter * -SearchBase "OU=Computers On Domain,DC=vinte,DC=com"
#$Computers = Get-ADComputer -Filter * -SearchBase "OU=Computers On Domain,DC=vinte,DC=com"
$User = "Soporte"
$Pass = ConvertTo-SecureString "Passw0rd1!" -AsPlainText -Force
$AdmGroup = "Administradores"


ForEach ($Computer In $Computers)
{
 
    invoke-command -ComputerName $Computer {
        param($User, $Passm, $AdmGroup)
        New-LocalUser -Name $User -Password $Pass
        Add-LocalGroupMember -Group $AdmGroup -Member $Soporte
    } -Args $User $Pass $AdmGroup
}
 