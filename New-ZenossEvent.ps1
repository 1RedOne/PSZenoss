#Create a new event
Function New-ZenossEvent{
 Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Summary,

        # Param2 help description
        $device="cho3w5ap02.corpstage.transunion.com",$component,$severity
    )

$data = @{summary=$Summary;device=$device;component=$component;severity=$severity;evclasskey=''} 

$body = @{action="EventsRouter";method="add_event";data=@($data);type='rpc';tid=432} | ConvertTo-Json 

invoke-restmethod "http://chmgl5mn07.corpstage.transunion.com:8080/zport/dmd/Events/evconsole_router" `
    -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' | 
    tee -variable test

    $("Response: $($test.result.msg), $($test.result.success)")
}