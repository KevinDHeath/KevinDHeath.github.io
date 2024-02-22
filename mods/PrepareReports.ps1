# Script to prepare the code coverage reports for a release

# Set variables
$root = (Get-ChildItem Env:USERPROFILE).Value + '\source\repos\github'
$target = "$root\KevinDHeath.github.io"
$report = "$root\NuGetPackages\test\Unit\[]\TestResults\reports"

# Check the target folder exist
if( !(Test-Path "$target\$project") ) { Write-Host "Target folder $target\$project does not exist." -ForegroundColor Red; Exit }

function Copy_Reports {
  param($tests, $folder)
  $rptPath = $report.replace( '[]', $tests )

  # Check the reports folder exist
  if( !(Test-Path "$rptPath") ) { Write-Host "Reports folder $rptPath does not exist." -ForegroundColor Red ; Return }
  $destPath = "$target\codecoverage\$folder"
  
  # Copy the badge files
  if( (Test-Path "$rptPath\badges") ) {
    Write-Host "Copying badges from: $rptPath\badges"
    Copy-Item -Path "$rptPath\badges\badge_branchcoverage.svg" -Destination "$destPath"
    Copy-Item -Path "$rptPath\badges\badge_combined.svg" -Destination "$destPath"
    Copy-Item -Path "$rptPath\badges\badge_linecoverage.svg" -Destination "$destPath"
    Copy-Item -Path "$rptPath\badges\badge_methodcoverage.svg" -Destination "$destPath"
  }

  # Copy the HTML files
  if( (Test-Path "$rptPath\html") ) {
    Write-Host "Copying report from: $rptPath\html"
    Copy-Item -Path "$rptPath\html\" -Destination "$destPath\" -Recurse -ErrorAction SilentlyContinue
  }

  # Reset archive attribute on all copied files
  Get-ChildItem -Path "$destPath\" -Recurse -File -Include "*.*" | Where-Object {
    ($_.Attributes -band [IO.FileAttributes]::Archive) } | ForEach-Object { $_.Attributes += 'Archive' };
}

# Perform tasks  
Copy_Reports 'Core.Tests' 'core'
Copy_Reports 'Helper.Tests' 'helpers'
