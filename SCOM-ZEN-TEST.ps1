$user = "SCOMTest"
$pass = "dCxrwM"

$device = 'cho3w5ap02.corpstage.transunion.com'
$deviceUrl = "http://chmgl5mn07.corpstage.transunion.com:8080/zport/dmd/Devices/Server/Microsoft/Windows/Devices/devices/$device"

$base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

invoke-restmethod $deviceUrl -Headers @{Authorization=("Basic {0}" -f $base64)} 

#experimental, creating a new event
#$data = @{Device="$device";Summary="TestEvent";Component="Appinfo";Severity='Critical';evclasskey='/Status'} | ConvertTo-Json -Compress
#$body = @{action="Events";method="add_event";data=$data;tid=1} | ConvertTo-Json -Compress
#
#invoke-restmethod "http://chmgl5mn07.corpstage.transunion.com:8080/zport/dmd/Events/" -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post


#get list of devices
$data = @{uid='/Server/Linux'} | ConvertTo-Json -Compress
$body = @{action="DeviceRouter";method="getDevices";data=$data;type='rpc';tid=1} | ConvertTo-Json -Compress

invoke-restmethod "http://chmgl5mn07.corpstage.transunion.com:8080/zport/dmd/device_router/" `
    -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' | 
    tee -variable test