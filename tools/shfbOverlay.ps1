# Script to overlay modifications for SandCastle Help File Builder output
$root = Split-Path -Path "$PSScriptRoot" -Parent
$mods = "$root\tools"
$iconPath = "$mods\icons"

function Copy_Artifacts {param($project, $icon)
  $target = "$root\$project" # Check the target folder exist
  if(!(Test-Path "$target")) { Write-Host "Target $target does not exist." -ForegroundColor Red; return; }
  # Replace the files
  Copy-Item -Path "$mods\css\*.css" -Destination "$target\css" -PassThru | ForEach-Object { Write-Host $_.FullName }
  Copy-Item -Path "$icon" -Destination "$target\icons\favicon.ico" -PassThru | ForEach-Object { Write-Host $_.FullName }
  Copy-Item -Path "$mods\$project\*" -Destination "$target" -Recurse -Force -PassThru | ForEach-Object { Write-Host $_.FullName }
  Get-ChildItem -Path "$target\" -Recurse -File -Include "*.*" | Where-Object {
    ($_.Attributes -band [IO.FileAttributes]::Archive) } | ForEach-Object { $_.Attributes += 'Archive' };
}

Copy_Artifacts 'nuget' "$iconPath\icon-blue.ico"
Copy_Artifacts 'shfb'  "$iconPath\icon-blue.ico"
Copy_Artifacts 'score' "$iconPath\grass-score.ico"