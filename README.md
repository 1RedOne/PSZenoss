# PSZenoss
============

A PowerShell Module for working with Zenoss
<img class="alignnone wp-image-2172 size-large" src="https://foxdeploy.files.wordpress.com/2015/03/introtodsc.jpg?w=705" alt="IntroToDsc" width="705" height="154" />
Installation
------------
 * Copy the "PSZenoss" folder into your module path. Note: You can find an
appropriate directory by running `$ENV:PSModulePath.Split(';')`.
 * Run `Import-Module PSZenoss` from your PowerShell command prompt.
 * If you're using PowerShell v3.0 or higher, you don't have to import the module on your own, it will automatically be done for you

 Usage
 -----
 
###Connecting your Account###
    Connect-ZenossInstance -ClientID Username -password ****** 
    #Credentials persist in secure storage and are automatically imported when you use a cmdlet in this module.
 
 Once connected, you can connect to any of the endpoints [listed in the Reddit API Documentation here.](https://www.reddit.com/dev/api)
 
    Get-ZenossDevice
   
    name               : 1RedOne
    hide_from_robots   : False
    gold_creddits      : 0
    link_karma         : 2674
    comment_karma      : 19080
    over_18            : True
    is_gold            : False
    is_mod             : False
    gold_expiration    : 
    has_verified_email : True
    inbox_count        : 2
    Created Date       : 1/20/2010 6:44:21 PM

... gets you information about your account including karma and account creation date

####Links####

**Most of these are out of date with the new Rest method, and will be revamped**

    Get-ZenossEvent

... gets you a nicely formatted table of the current front page links.

  
###To come###

* Making Posts
* imgur uploads
* Your suggestions?
* Multiple Account Support
