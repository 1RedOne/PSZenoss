<#
.Synopsis
   Use this Cmdlet to Close a Zenoss Event
.DESCRIPTION
   Use this cmdlet to close events in Zenoss.  Requires a evid parameter.  Does not operate on multiple evids.  This cmdlet does not accept pipeline input.
.EXAMPLE
   Close-ZenossEvent -evid 005056a5-7c3e-9c9c-11e5-fcd8cbbdb0f1 -message "Closed with PowerShell!"
   
   >Closes an event 
.PARAMETER evid
   An EVID to close
.PARAMETER url
   Base URL of the Zenoss Instance, e.g. http://servername:8080
#>
function Close-ZenossEvent
{
    [CmdletBinding(DefaultParameterSetName='De', 
                  SupportsShouldProcess=$true)]
    
    Param
    (
        # to get details of a particular event
        [Parameter(ParameterSetName='evid')]
        [String]
        $evid,

        # base url of the Zenoss Instance
        [Parameter(ParameterSetName='evid')]
        [String]
        $URL
    )

    Begin
    {
        $user = "SCOMTest"
        $pass = $null
        $base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

    }
    Process{

        
        #PowerShell's convert to JSON cmdlet was incorrectly parsing this value, instead we're using a known valid capture from Fiddler
        $params = @{evids=@($evid)}
        $body = @{action="EventsRouter";method="close";type='rpc';data=@($params);tid='432'} | ConvertTo-Json -depth 3

        Write-Debug "Test value for `$result"
        $results = invoke-restmethod "$url/zport/dmd/Events/evconsole_router" `
            -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' 
            
        Write-output "Operation success: $($results.result.success)"
    
    }

#EoF
}