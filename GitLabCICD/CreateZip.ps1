param ($CI_COMMIT_TAG, $CI_PIPELINE_IID)

Import-Module ./sw_shared/scripts/SemanticVersioningHelpers.psm1

#### Script Main

$major, $minor, $patch, $build, $isRelease = getSemanticVersionData $CI_COMMIT_TAG $CI_PIPELINE_IID
$zipName = ""
if ($isRelease)
{
    $zipName = "CppCheck_v${major}.${minor}.${patch}+${build}.zip"
}
else
{
    $zipName = "CppCheck_v${major}.${minor}.${patch}-DEV+${build}.zip"
}

Remove-Item .\bin\*.pdb
Remove-Item .\bin\*.exp
Remove-Item .\bin\*.lib
New-Item -Path '.\ToDeploy' -Type Directory
Compress-Archive -Update -Path .\bin\* -DestinationPath .\ToDeploy\$zipName
