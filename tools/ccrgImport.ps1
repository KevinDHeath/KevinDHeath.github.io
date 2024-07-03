# Script to import the code coverage report generator output for NuGetPackages unit tests
$target = Split-Path -Path "$PSScriptRoot" -Parent
$root = Split-Path -Path "$target" -Parent
$source = "$root\NuGetPackages\tests\Unit\TestResults\[]\reports"
$project = "code"
if( !(Test-Path "$target\$project") ) { Write-Host "Target folder $target\$project does not exist." -ForegroundColor Red; Exit }

function Copy_Reports {
  param($folder)
  $rptPath = $source.replace( '[]', $folder )
  if( !(Test-Path "$rptPath") ) { Write-Host "Reports folder $rptPath does not exist." -ForegroundColor Red ; Return }
  $destPath = "$target\$project\$folder"

  Write-Host "Copying report from: $rptPath"
  Copy-Item -Path "$rptPath\Html\*.*" -Destination "$destPath\html" -ErrorAction SilentlyContinue
  Copy-Item -Path "$rptPath\Badges\badge_branchcoverage.svg" -Destination "$destPath"
  Copy-Item -Path "$rptPath\Badges\badge_combined.svg" -Destination "$destPath"
  Copy-Item -Path "$rptPath\Badges\badge_linecoverage.svg" -Destination "$destPath"
  Copy-Item -Path "$rptPath\Badges\badge_methodcoverage.svg" -Destination "$destPath"
  Get-ChildItem -Path "$destPath\" -Recurse -File -Include "*.*" | Where-Object {
   ($_.Attributes -band [IO.FileAttributes]::Archive) } | ForEach-Object { $_.Attributes += 'Archive' };
}
Copy_Reports 'core'
Copy_Reports 'helper'