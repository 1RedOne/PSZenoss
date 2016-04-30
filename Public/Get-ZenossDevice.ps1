<#
.Synopsis
   Use this Cmdlet to get a list of all devices in Zenoss
.DESCRIPTION
   Get all devices, in Zenoss, can be used for filtering for other cmdlets
.EXAMPLE
   Get-ZenossEvent 

   >Returns a listing of all of the events in descending order
.EXAMPLE
   Get-ZenossEvent -evid ((Get-zenossEvent).result.events[0].evid)

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

.EXAMPLE
  Get-ZenossEvent -DeviceName CHDTW1T


count         : 4
firstTime     : 2016-03-22 10:06:40
severity      : 5
evid          : 005056a5-7c3e-9c9c-11e5-f03faec4b12c
eventClassKey : 
component     : @{url=; text=; uid=; uuid=}
summary       : Device is DOWN!
eventState    : New
device        : @{url=/zport/dmd/goto?guid=1f99f022-f0d3-4c75-90f2-a52fca708303; text=CH_IT-03.dev.contoso.com; uuid=1f99f022-f0d3-4c75-90f2-a52fca708303; 
                uid=/zport/dmd/Devices/Server/Microsoft/Windows/DEV TEST/devices/CH_IT-03.dev.contoso.com}
eventClass    : @{text=/Status/WinRM/Ping; uid=/zport/dmd/Events/Status/WinRM/Ping}
lastTime      : 2016-03-22 10:21:40
message       : Device is DOWN!
DeviceName    : CHDTW1TST03.corpdev.contoso.com

.INPUTS
   Does not take pipeline input.
.OUTPUTS
   Outputs PowerShell Custom Object, or an array of objects, containing information about Zenoss Events
.PARAMETER DeviceName
   If provided, returns all Zenoss Events for a given device in Zenoss
.PARAMETER evid
   EVID of an existing Zenoss event 
.PARAMETER URL
   Base URL of the Zenoss Instance, e.g. http://servername:8080
#>
Function Get-ZenossDevice
{
    [CmdletBinding(DefaultParameterSetName='DeviceName', 
                  SupportsShouldProcess=$true)]
    
    Param
    (
        [String]
        $URL ,
        
        # Param1 help description
        [Parameter(ParameterSetName='DeviceName')]
        [Alias("p1")] 
        $DeviceName       

    )

    Begin
    {
        $user = "SCOMTest"
        $pass = $null
        $base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

    }
    Process
    {
        
        $data = $NULL| ConvertTo-Json -Compress
        $body = @{action="DeviceRouter";method="getDevices";data=$data;type='rpc';tid='4832'} | ConvertTo-Json -Compress

        invoke-restmethod "$url/zport/dmd/device_router/" `
            -Headers @{Authorization=("Basic {0}" -f $base64)} -Body $body -Method post -ContentType 'application/json' | 
            tee -variable test

        if ($PSCmdlet.ParameterSetName -eq 'DeviceName'){
            return $test.result.devices | Where-Object DeviceName -eq $DeviceName
            }

        return $test.result.devices
    }

#EoF
}
