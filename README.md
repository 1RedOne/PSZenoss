# PSZenoss
============


<img class="alignnone wp-image-2172 size-large" src="https://raw.githubusercontent.com/1RedOne/PSZenoss/master/img/Zenoss_logo_new.png"/>
###A PowerShell Module for working with Zenoss###

Installation
------------
 * Copy the "PSZenoss" folder into your module path. Note: You can find an
appropriate directory by running `$ENV:PSModulePath.Split(';')`.
 * Run `Import-Module PSZenoss` from your PowerShell command prompt.
 * If you're using PowerShell v3.0 or higher, you don't have to import the module on your own, it will automatically be done for you

 Usage
 -----
 
 You can use this module to pull information about devices in Zenoss, see events, even create events.
 
###Connecting to your Zenoss Instance###

 Every cmdlet in this module takes a parameter of `-URL` which should be the base url of your Zenoss Instance, like so http://zenoss:8080.  If you'd like to use this value globally across all cmdlets, you can use a global variable of $global:url = "http://zenoss:8080", to automatically provide this value for all cmdlets.

 There are many more endpoints available, we've only made cmdlets for the following.

| Cmdlet        | Released      |
| ------------- |:-------------:|
| Get-ZenossDevice      | v0.6    |
| Get-ZenossEvent | v0.6      | 
| New-ZenossEvent | v1.0 |
| Close-ZenossEvent      | v1.0 |
| Update-ZenossEventLog | v1.0 |

 Using the scaffolding we've provided, you can extend this module to any of Zenoss's other endpoints.  I'd recommend using the fan created documentation made by Pat Baker, [listed in the wonderful API Documentation here.](http://search.cpan.org/~patbaker/Zenoss-1.11/lib/Zenoss/Router/Events.pm#METHODS)
 
####Get-ZenossDevice####
    Get-ZenossDevice
   
    
    Created Date       : 1/20/2010 6:44:21 PM

 ... gets you information about all your devices in Zenoss

####Get-ZenossEvent####


    Get-ZenossEvent -DeviceName CHDTW1T
    count         : 4
    firstTime     : 2016-03-22 10:06:40
    severity      : 5
    evid          : 005056a5-7c3e-9c9c-11e5-f03faec4b12c
    eventClassKey : 
    component     : @{url=; text=; uid=; uuid=}
    summary       : Device is DOWN!
    eventState    : New
    device        : @{url=/zport/dmd/goto?guid=1f99f022-f0d3-4c75-90f2-a52fca708303; text=CHDTW1TST03.corpdev.contoso.com; uuid=1f99f022-f0d3-4c75-90f2-a52fca708303; 
    id=/zport/dmd/Devices/Server/Microsoft/Windows/DEV TEST/devices/CHDTW1TST03.corpdev.contoso.com}
    eventClass    : @{text=/Status/WinRM/Ping; uid=/zport/dmd/Events/Status/WinRM/Ping}
    lastTime      : 2016-03-22 10:21:40
    message       : Device is DOWN!
    DeviceName    : CHDTW1TST03.corpdev.contoso.com

 ... gets you a listing of all of the events for a particular device in reverse chronological order

####Update-ZenossEventLog###

    Update-ZenossEventLog -evid 005056a5-7c3e-9c9c-11e5-fcd8cbbdb0f1 -message "Updated with PowerShell!"
   
    >Operation completed
 
 ...updates an event with new log text

####New-ZenossEvent####

     New-ZenossEvent -Summary "Test new event from PowerShell" -component "Test Component" -severity 5 -device cho3w5ap02.corpstage.contoso.com
     Response: Created event, True

     evid                                                            response
     ----                                                            --------
     005056a5-7c3e-a0c2-11e6-07d5d415b6aa                            True

 ...creates a new event and replies back with the EVID.  Annoyingly enough, the Method for creating a new event does not actually reply with the evid of the event.  Instead, it replies back with a generic JSON receipt confirming the event was created.  Our code mitigates this by generating a unique ID when we create a Zenoss Event.

 ###Example Scenario: Creating a Zenoss Event from a SCOM Alert###


