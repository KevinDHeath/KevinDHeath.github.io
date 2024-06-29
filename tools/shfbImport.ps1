# Script to import the shfb output for a project
param ([Parameter(Mandatory=$true)][string]$project)
$project = $project.ToLower()
if(!($project -eq 'nuget') -And !($project -eq 'shfb') -And !($project -eq 'score'))
{ Write-Host "Parameter must equal nuget, shfb, or score" -ForegroundColor Red; Exit }

$target = Split-Path -Path "$PSScriptRoot" -Parent # target is the location in this repo
$root = Split-Path -Path "$target" -Parent # root contains all the repos
if( ($project -eq 'nuget') -Or ($project -eq 'shfb')) { $repo = 'NuGetPackages' } else { $repo = 'Samples' }
$source = [string]::Format( "{0}\{1}\docs\bin\{2}", $root, $repo, $project ) # source is the shfb output
if( !(Test-Path "$source") ) { Write-Host "Source folder $source does not exist." -ForegroundColor Red; return }
if( !(Test-Path "$target\$project") ) { Write-Host "Target folder $target\$project does not exist." -ForegroundColor Red; return }

function Copy_Documentation {
  $toPath = "$target\$project"
  Write-Host "About to delete all files in $toPath" -ForegroundColor Yellow
  $confirm = Read-Host "Do you want to? [y to confirm] "
  if( $confirm.ToLower() -eq 'y' -And ( Test-Path "$toPath" ) ) { Remove-Item -Path "$toPath\*" -Recurse | Out-Null } else { return }
  
  Copy-Item -Path "$source\" -Destination "$target\" -Recurse -ErrorAction SilentlyContinue
  Get-ChildItem -Path "$target\$project\" -Recurse -File -Include "*.*" | Where-Object {
    ($_.Attributes -band [IO.FileAttributes]::Archive) } | ForEach-Object { $_.Attributes += 'Archive' };
  Write-Host "Files copied from: $source" -ForegroundColor Green
  Write-Host "Files copied to: $toPath" -ForegroundColor Green
}
Copy_Documentation