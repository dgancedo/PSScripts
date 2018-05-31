#Description: Simple script to inventory VM's and hosts connected to vCenter
#Author: dgacendo@trans.com.ar
#Date: 20180530

Get-Module -ListAvailable PowerCli* | Import-Module

$vc = Read-Host -Prompt "Input vCenter name"
$creed = Get-Credential -Message "Input vCenter credentials"

Connect-VIServer -Server $vc -Credential $creed

$vmdata = Get-VM -name * | Get-HardDisk | Select-Object @{N="VM";E={$_.Parent.Name}},@{N="CPU";E={$_.Parent.numCpu}},@{N="Memory Total MB";E={$_.Parent.memoryMb}},@{N="Provisioned Space";E={$_.Parent.ProvisionedSpaceGB}},@{N="Used Space";E={$_.Parent.UsedSpaceGB}},@{N="Storage GB";E={$_.CapacityGB}}

$hostdata = get-vmhost * | Select-Object Name,ConnectionState,Version,Manufacturer,Model,NumCpu,CpuTotalMhz,CpuUsageMhz,MemoryTotalGB,MemoryUsageGB
foreach ($line in $vmdata){
    export-csv -InputObject $line -path $vc"_vms.csv" -Append
}
foreach ($line in $hostdata){
    export-csv -InputObject $line -path $vc"_hosts.csv" -Append
}