<#
.Synopsis
   Use this Cmdlet to update the log of a Zenoss Event
.DESCRIPTION
   Long description
.EXAMPLE
   Update-ZenossEventLog -evid 005056a5-7c3e-9c9c-11e5-fcd8cbbdb0f1 -message "Updated with PowerShell!"
   
   Operation was a True

   >Updates an event with new log text
.EXAMPLE
   Update-ZenossEventLog -evid ((Update-ZenossEventLog).result.events[0].evid)

   >Get detailed info on a particular event
prodState             : Test
firstTime             : 2016-03-17 10:32:24
device_uuid           : 4aca66ff-109c-4cf8-9391-ab2d2c4670eb
eventClassKey         : WindowsServiceLog
agent                 : zenpython
dedupid               : CH_IT-03.dev.contoso.com|sppsvc|/Status|WindowsService|5
Location              : {}
component_url         : /zport/dmd/goto?guid=7b9ec357-78d8-43a5-8e64-0eca1d391f20
ownerid               : 
eventClassMapping_url : 
eventClass            : /Status
id                    : 005056a5-7c3e-9c9c-11e5-ec5573f3f106
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
.PARAMETER evid
   EVID of the event to update
.PARAMETER message
   Body text of the log content to add
.PARAMETER url
   Base URL of the Zenoss Instance, e.g. http://servername:8080
#>
function Update-ZenossEventLog
{
    [CmdletBinding(DefaultParameterSetName='De', 
                  SupportsShouldProcess=$true)]
    
    Param
    (

        [String]
        $URL,

        # event in Zenoss to update
        [Parameter(ParameterSetName='evid')]
        [String]
        $evid,

        # Message to append
        [Parameter(ParameterSetName='evid',Mandatory=$true)]
        [String]
        $message
    )

    Begin
    {
        $user = "SCOMTest"
        $pass = $null
        $base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

    }
    Process{
    
        $params = @{evid=$evid;message=$message}
        $body = @{action="EventsRouter";method="write_log";type='rpc';data=@($params);tid='432'} | ConvertTo-Json 

        Write-Debug "Test value for `$resulkt"
        $results = invoke-restmethod "$url/zport/dmd/evconsole_router/" `
            -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' -ErrorAction STOP
            
        Write-Verbose "Operation was a $($results.result.success)"
    
    }

#EoF
}