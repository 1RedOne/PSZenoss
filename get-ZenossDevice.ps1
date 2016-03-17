Function Get-ZenossDevice{
#WORKING GET DEVICES HOLY MOTHER OF HAM
$data = $NULL| ConvertTo-Json -Compress
$body = @{action="DeviceRouter";method="getDevices";data=$data;type='rpc';tid='4832'} | ConvertTo-Json -Compress

invoke-restmethod "http://chmgl5mn07.corpstage.transunion.com:8080/zport/dmd/device_router/" `
    -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' | 
    tee -variable test

    $test.result.devices}