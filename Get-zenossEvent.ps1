#Next steps
# - step back out from all events for this devioce, to display all events for all devices
# - add param support to get all evns for a particular device name
# _ convert from JSOn into pures powershell

<#
.Synopsis
   Use this Cmdlet to get a list of Zenoss Events
.DESCRIPTION
   Long description
.EXAMPLE
   Get-ZenossEvent 

   >Returns a listing of all of the events in descending order
.EXAMPLE
   Get-ZenossEvent -evid ((Get-zenossEvent).result.events[0].evid)


uuid   : 9afa1907-bc01-4e22-9246-23c9b7599153
action : EventsRouter
result : @{event=System.Object[]; success=True}
tid    : 432
type   : rpc
method : detail

prodState             : Test
firstTime             : 2016-03-17 10:32:24
device_uuid           : 4aca66ff-109c-4cf8-9391-ab2d2c4670eb
eventClassKey         : WindowsServiceLog
agent                 : zenpython
dedupid               : cho3w5ap02.corpstage.transunion.com|sppsvc|/Status|WindowsService|5
Location              : {}
component_url         : /zport/dmd/goto?guid=7b9ec357-78d8-43a5-8e64-0eca1d391f20
ownerid               : 
eventClassMapping_url : 
eventClass            : /Status
id                    : 005056a5-7c3e-9c9c-11e5-ec5573f3f106

.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-ZenossEvent
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true)]
    
    Param
    (
        # Param1 help description
        [Parameter(ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(0,5)]
        [ValidateSet("sun", "moon", "earth")]
        [Alias("p1")] 
        $Param1,

        # Param2 help description
        [Parameter(ParameterSetName='Parameter Set 1')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [ValidateScript({$true})]
        [ValidateRange(0,5)]
        [int]
        $Param2,

        # to get details of a particular event
        [Parameter(ParameterSetName='evid')]
        [String]
        $evid
    )

    Begin
    {
        foreach ($cred in import-csv .\creds.crd ){
            New-Variable -Name user -Value $cred.user
            New-Variable -Name pass -Value $cred.pass
            }
        $base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

    }
    Process
    {
        if ($PSCmdlet.ParameterSetName -eq 'evid')
        {
        
        $params = @{evid=$evid}
        $body = @{action="EventsRouter";method="detail";type='rpc';data=@($params);tid='432'} | ConvertTo-Json 

        invoke-restmethod "http://chmgl5mn07.corpstage.transunion.com:8080/zport/dmd/evconsole_router/" `
            -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' | 
            tee -variable test

        }

    else{
        #if evid wasn't provided
        #valid classes : device, component, eventclass
        #$data.params.device = 'cho3w...'
        #$params = @{device='cho3w5ap02.corpstage.transunion.com'}
        #$body =   @{action="EventsRouter";method="query";type='rpc';data=@();tid='432'} |            ConvertTo-Json -depth 3
        $body =   @"
[{
	"action": "EventsRouter",
	"method": "query",
	"data": [{
		"uid": "/zport/dmd/Devices/Server/Microsoft/Windows/STAGE TEST/devices/cho3w5ap02.corpstage.transunion.com",
		"params": {
			"eventState": [0, 1],
			"severity": [5, 4, 3, 2],
			"excludeNonActionables": false
		},
		"keys": ["eventState", "severity", "device", "component", "eventClass", "summary", "firstTime", "lastTime", "count", "evid", "eventClassKey", "message"],
		"page": 1,
		"start": 0,
		"limit": 200,
		"sort": "severity",
		"dir": "DESC"
	}],
	"type": "rpc",
	"tid": 385
}]
"@ 
        invoke-restmethod "http://chmgl5mn07.corpstage.transunion.com:8080/zport/dmd/evconsole_router/" `
            -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' | 
            tee -variable test
}


    
    }
    End
    {
    $test.result.event
    }
}