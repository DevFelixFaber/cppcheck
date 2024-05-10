param ($CI_COMMIT_TAG, $CI_PIPELINE_IID, $CI_JOB_TOKEN, ${CI_API_V4_URL}, ${CI_PROJECT_ID})

Import-Module ./sw_shared/scripts/GitLab.psm1
Import-Module ./sw_shared/scripts/SemanticVersioningHelpers.psm1

#### Script Main
$major, $minor, $patch, $build, $isRelease = getSemanticVersionData $CI_COMMIT_TAG $CI_PIPELINE_IID
$releaseZip = Get-Item .\ToDeploy\*.zip
if ($releaseZip.count -ne 1)
{
    $matchCount = $releaseZip.count
    Write-Error "Matched ${matchCount} items for .\ToDeploy\*.zip. Expected exactly one."
    exit -1
}

$versionString = "${major}.${minor}.${patch}"
$releaseName = "CppCheck $versionString" 

# Upload to generic package registry and release
$url = uploadFileToGenericPackageRegistry $releaseZip "CppCheck" "v${major}.${minor}.${patch}" $CI_JOB_TOKEN $CI_API_V4_URL $CI_PROJECT_ID
$description = "TODO: Description!"
createGitLabRelease $releaseName $description $CI_COMMIT_TAG $releaseName $url
