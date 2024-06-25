## Check that IIS Express is installed
$iispath = "$Env:PROGRAMFILES\IIS Express"
if( !(Test-Path "$iispath") ) {
  Write-Host "IIS Express cannot be found in $iispath" -ForegroundColor Red
  Write-Host "See https://learn.microsoft.com/en-us/iis/extensions/introduction-to-iis-express/iis-express-overview"
  Exit
}

Set-Location "$iispath"
## https://learn.microsoft.com/en-us/iis/extensions/using-iis-express/running-iis-express-from-the-command-line
#.\iisexpress.exe /site:Testing # use https protocol
.\iisexpress.exe /path:$PSScriptRoot /port:44399
Set-Location "$PSScriptRoot"