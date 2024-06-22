# Script to overlay Sandcastle modifications

# Set variables
$source = (Get-ChildItem Env:USERPROFILE).Value + '\source\repos\github\KevinDHeath.github.io'
$target = 'C:\Temp\Documentation'

# Check the source and target folders exist
if( !(Test-Path "$source") ) { Write-Host "Source folder $source does not exist." -ForegroundColor Red; Exit }
if( !(Test-Path "$target") ) { Write-Host "Target folder $target does not exist." -ForegroundColor Red; Exit }

$modsPath = "$source\mods"
$iconPath = "$modsPath\icons"

function Copy_HtmlArtifacts {
  param($project, $icon)
  Copy-Item -Path "$modsPath\css\*.css" -Destination "$target\$project\css" -PassThru | ForEach-Object { Write-Host $_.FullName }
  Copy-Item -Path "$icon" -Destination "$target\$project\icons\favicon.ico" -PassThru | ForEach-Object { Write-Host $_.FullName }
  Copy-Item -Path "$modsPath\html\$project\*.htm" -Destination "$target\$project\html" -PassThru | ForEach-Object { Write-Host $_.FullName }
}

Copy_HtmlArtifacts  'nuget' "$iconPath\icon-blue.ico"
Copy_HtmlArtifacts  'shfb' "$iconPath\icon-blue.ico"
#Copy_HtmlArtifacts  'grassscore' "$iconPath\grass-score.ico"
