# Script to prepare the code coverage reports for a release

# Set variables
$root = (Get-ChildItem Env:USERPROFILE).Value + '\source\repos\github'
$target = "$root\KevinDHeath.github.io"
$report = "$root\NuGetPackages\tests\Unit\TestResults\[]\reports"

# Check the target folder exist
if( !(Test-Path "$target\$project") ) { Write-Host "Target folder $target\$project does not exist." -ForegroundColor Red; Exit }

function Copy_Reports {
  param($folder)
  $rptPath = $report.replace( '[]', $folder )

  # Check the reports folder exist
  if( !(Test-Path "$rptPath") ) { Write-Host "Reports folder $rptPath does not exist." -ForegroundColor Red ; Return }
  $destPath = "$target\codecoverage\$folder"

  Write-Host "Copying report from: $rptPath"
  Copy-Item -Path "$rptPath\Html\*.*" -Destination "$destPath\html" -ErrorAction SilentlyContinue
  Copy-Item -Path "$rptPath\Badges\badge_branchcoverage.svg" -Destination "$destPath"
  Copy-Item -Path "$rptPath\Badges\badge_combined.svg" -Destination "$destPath"
  Copy-Item -Path "$rptPath\Badges\badge_linecoverage.svg" -Destination "$destPath"
  Copy-Item -Path "$rptPath\Badges\badge_methodcoverage.svg" -Destination "$destPath"

  # Reset archive attribute on all copied files
  Get-ChildItem -Path "$destPath\" -Recurse -File -Include "*.*" | Where-Object {
   ($_.Attributes -band [IO.FileAttributes]::Archive) } | ForEach-Object { $_.Attributes += 'Archive' };
}

# Perform tasks  
Copy_Reports 'core'
Copy_Reports 'helper'
