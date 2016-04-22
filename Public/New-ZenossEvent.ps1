<#
.Synopsis
   Use this cmdlet to make a new event in Zenoss 
.DESCRIPTION
   Use this cmdlet to make a new event in Zenoss if you want to
.EXAMPLE
   New-ZenossEvent -Summary "Test new event from PowerShell" -component "Test Component" -severity 5 -device cho3w5ap02.corpstage.contoso.com
Response: Created event, True

evid                                                            response
----                                                            --------
005056a5-7c3e-a0c2-11e6-07d5d415b6aa                            True

.EXAMPLE
   When used in a Runbook
 New-ZenossEvent -Summary $alert.Name `
  -component (($alerts.MonitoringObjectFullName.Split(':')[0])) `
  -severity 5 -device $alert.MonitoringObjectDisplayName -evclass '/Status/SCOMAlert' | tee -Variable evid 
.PARAMETER Summary
   When used in a runbook, should be assigned the value of $alert.Name
.PARAMETER Device
   The name of the device to assign an event to in Zenoss.  Note: Device does NOT need to be created in Zenoss first.  
.PARAMETER Component
   Can be any value; in a runbook, this corresponds to the Monitored Object from the SCOM Alert
.PARAMETER Severity
   A numerical value to determine the icon and severity assigned to a Zenoss Event. 5 = critical, 4 = warning, 3 = information
.PARAMETER EVClass
   Defaults to 'Status/SCOMAlert' which is a custom class created in SCOM, used to help filter the source of events in Zenoss
.PARAMETER URL
   Base URL of the Zenoss Instance, e.g. http://servername:8080
#>
Function New-ZenossEvent{[CmdletBinding()]
 Param
    (
        # Summary body text for the new event
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Summary,

        # Device to tag the event on to 
        $device="cho3w5ap02.corpstage.contoso.com",
        
        # The component name for the ticket
        $component,
        
        # The severity value of 1,2, or 5
        $severity,
        
        # Custom Class for SCOM Alerts
        $evclass='/Status/SCOMAlert',

        [String]
        $URL
    )
    
    begin{
        $user = "SCOMTest"
        $pass = $null
        $base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))
    }

 process{
        
        $guid = [guid]::NewGuid()
    
        $summary = "$summary
    
        SCOM Automation GUID: $guid
        "

        #Convert SCOM Alert Severity into Zenoss Severity, if needed
        $severity = switch ($severity)
        {
            'Information' {'2'}
            'Warning'     {'2'}
            'Error'       {'5'}
            Default {$severity}
        }

    $data = @{summary=$summary;device=$device;component=$component;severity=$severity;evclasskey=$guid;evclass=$evclass} 

    $body = @{action="EventsRouter";method="add_event";data=@($data);type='rpc';tid=432} | ConvertTo-Json 

    $response = invoke-restmethod "$URL/zport/dmd/Events/evconsole_router" `
        -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' 
    
        write-debug "Debug here to test the output of `$response, which contains the response"
        $("Response: $($response.result.msg), $($response.result.success)")

        start-sleep -Milliseconds 1000
        $evid = Get-ZenossEvent | ? Summary -like "*$guid*" | Select -expand evid
        [pscustomobject]@{evid=$evid;response=$response.result.Success}

        }
}