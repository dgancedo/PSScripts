param (
    [Parameter(Mandatory=$true)][string]$IP
)
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

$AllConnectors = Get-ReceiveConnector *\"Default Frontend"*

foreach ($connector in $AllConnectors){
    $IPRange = $connector.RemoteIPRanges
    $IPRange -= $IP
    $connector | Set-ReceiveConnector -RemoteIPRanges $IPRange

}