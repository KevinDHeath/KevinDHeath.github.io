# Script to overlay Sandcastle modification

$github = (Get-ChildItem Env:USERPROFILE).Value + '\source\repos\github'
$target = 'C:\Temp\Documentation' # $PSScriptRoot

$iconPath = "$github\HomeBase\docs\Common\Theme"
$modsPath = "$github\KevinDHeath.github.io\mods"

function Copy_BasicArtifacts {
  param($project, $icon)
  Copy-Item -Path "$modsPath\css\*.css" -Destination "$target\$project\css" -PassThru | ForEach-Object { Write-Host $_.FullName }
  Copy-Item -Path "$iconPath\$icon" -Destination "$target\$project\icons\favicon.ico" -PassThru | ForEach-Object { Write-Host $_.FullName }
}

function Copy_HtmlArtifacts {
  param($project, $icon)
  Copy_BasicArtifacts $project $icon
  Copy-Item -Path "$modsPath\html\$project\*.htm" -Destination "$target\$project\html" -PassThru | ForEach-Object { Write-Host $_.FullName }
}

#Copy_BasicArtifacts 'CommonProjects' 'icon-orange.ico'
#Copy_BasicArtifacts 'EFCoreProjects' 'icon-orange.ico'
#Copy_BasicArtifacts 'MVVMProjects' 'icon-orange.ico'
#Copy_BasicArtifacts 'PrivateProjects' 'icon-orange.ico'

Copy_HtmlArtifacts  'nuget' 'icon-blue.ico'
Copy_HtmlArtifacts  'shfb' 'icon-blue.ico'
