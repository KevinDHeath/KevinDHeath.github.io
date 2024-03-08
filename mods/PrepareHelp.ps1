# Script to prepare the help documentation for a release
param ([Parameter(Mandatory=$true)][string]$project)
$project = $project.ToLower()
if( !($project -eq 'nuget') -And !($project -eq 'shfb') ) { Write-Host "Parameter must equal nuget or shfb" -ForegroundColor Red; Exit }

# Set variables
$source = 'C:\Temp\Documentation'
$target = (Get-ChildItem Env:USERPROFILE).Value + '\source\repos\github\KevinDHeath.github.io'

# Check the source and target folders exist
if( !(Test-Path "$source\$project") ) { Write-Host "Source folder $source\$project does not exist." -ForegroundColor Red; Exit }
if( !(Test-Path "$target\$project") ) { Write-Host "Target folder $target\$project does not exist." -ForegroundColor Red; Exit }

function Copy_Documentation {
  # Delete all files in destination
  $docPath = "$target\$project"
  Write-Host "About to delete all files in $docPath" -ForegroundColor Yellow
  $confirm = Read-Host "Do you want to? [y to confirm] "
  if( $confirm.ToLower() -eq 'y' -And ( Test-Path "$docPath" ) ) { Remove-Item -Path "$docPath\*" -Recurse | Out-Null }
 
  # Copy all file from source project to target location
  Copy-Item -Path "$source\$project\" -Destination "$target\" -Recurse -ErrorAction SilentlyContinue

  # Reset archive attribute on all copied files
  Get-ChildItem -Path "$target\$project\" -Recurse -File -Include "*.*" | Where-Object {
    ($_.Attributes -band [IO.FileAttributes]::Archive) } | ForEach-Object { $_.Attributes += 'Archive' };

  Write-Host "Files copied from $source\$project" -ForegroundColor Green
}

Copy_Documentation
