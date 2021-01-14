$PATH="C:\Program Files\Microsoft\Exchange Server\V15\Logging"
$DATE = (get-date).AddDays(-60)
foreach ($log in Get-ChildItem $PATH -Recurse -Filter *.LOG){
 if ($log.LastWriteTime -lt $DATE){
    #write-output $log.FullName $log.LastWriteTime
    Remove-Item $log.FullName -force -Verbose
 }
}
$PATH="C:\inetpub\logs\LogFiles\W3SVC1"
foreach ($log in Get-ChildItem $PATH -Recurse -Filter *.log){
 if ($log.LastWriteTime -lt $DATE){
    #write-output $log.FullName $log.LastWriteTime
    Remove-Item $log.FullName -force -Verbose
 }
}
$PATH="C:\inetpub\logs\LogFiles\W3SVC2"
foreach ($log in Get-ChildItem $PATH -Recurse -Filter *.log){
 if ($log.LastWriteTime -lt $DATE){
    #write-output $log.FullName $log.LastWriteTime
    Remove-Item $log.FullName -force -Verbose
 }
}