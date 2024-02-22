# Script to prepare for a release
param (
    [Parameter(Mandatory=$true)][string]$project # nuget or shfb
)
# Set variables
$root = (Get-ChildItem Env:USERPROFILE).Value + '\source\repos\github'
$source = 'C:\Temp\Documentation' # $PSScriptRoot
$target = "$root\KevinDHeath.github.io"
$report = "$root\NuGetPackages\test\Unit"

function Copy_Documentation {
  $output = $target # "C:\Temp\Test"

  # Delete all files in destination
  $destPath = "$output\$project"
  Write-Host "Delete all files in $destPath" -ForegroundColor Yellow
  $confirm = Read-Host "Do you want to? [y to confirm] "
  if( $confirm -eq 'y' -And ( Test-Path "$destPath" ) ) { Remove-Item -Path "$destPath\*" -Recurse | Out-Null }
 
  # Copy all file from source project to target location
  Copy-Item -Path "$source\$project\" -Destination "$output\" -Recurse -ErrorAction SilentlyContinue

  # Reset archive attribute on all copied files
  Get-ChildItem -Path "$output\$project\" -Recurse -File -Include "*.*" | Where-Object {
    ($_.Attributes -band [IO.FileAttributes]::Archive) } | ForEach-Object { $_.Attributes += 'Archive' }
}

# Parameter must be nuget or shfb
# Source and target must exist
Write-Host "Source: $source\$project"
Write-Host "Target: $target\$project"
Copy_Documentation

Write-Host "Report: $report"
