param(
  [Parameter(Mandatory=$true)]
  [string]$angularFile 
  # The path to the package.json
  # $angularFile = "TeamLead.Client\package.json"
)

$file = "Directory.Build.props"


#
# calculate
#

Write-Host "---"
Write-Host "Incrementing .NET version, changing: $($file), setting into: 'env:buildVersionNumber'"

$xml = new-object System.Xml.XmlDocument
$xml.load($file)

Write-Host $xml.Project.PropertyGroup.Copyright

$version = [version] $xml.Project.PropertyGroup.Version
Write-Host "From: $version"

$newVersion = "{0}.{1}.{2}.{3}" -f $version.Major, $version.Minor, ($version.Build + 1), $version.Revision
$newAngularVersion = "{0}.{1}.{2}" -f $version.Major, $version.Minor, ($version.Build + 1)

Write-Host "To  : $newVersion (for angular: $newAngularVersion)"

#
# change .NET version
#

Write-Host "---"
$xml.Project.PropertyGroup.Version = $newVersion
$xml.Save($file)
Write-Host ".NET changes saved"

#
# change Angular version
#

Write-Host "---"
Write-Host "Updating Angular version, changing: $($angularFile)"

if (!(Get-Module -ListAvailable -Name "newtonsoft.json")) {
    Install-Module -Name "newtonsoft.json" -Scope CurrentUser -Force
}

Import-Module "newtonsoft.json" -Scope Local

$json = (Get-Content $angularFile | Out-String) # read file
$package = [Newtonsoft.Json.JsonConvert]::DeserializeObject($json, [Newtonsoft.Json.Linq.JObject])

$package.version = $newAngularVersion

$json = [Newtonsoft.Json.JsonConvert]::SerializeObject($package, [Newtonsoft.Json.Formatting]::Indented)

# without extra param, this saves as UTF-16, with extra param as UTF-8 BOOM
# $json | Out-File -Encoding utf8 $angularFile
[System.IO.File]::WriteAllLines($angularFile, $json, [System.Text.UTF8Encoding]($False))

Write-Host "Angular changes saved"

#
# set variable
#

# This is for setting GA env. variable
# echo "::set-env name=buildVersionNumber::$newVersion"
# Write-Host "Environment variable: 'buildVersionNumber' was set"

# This is for setting Azure pipeline variable
Write-Host "##vso[task.setvariable variable=buildVersionNumber]$newVersion"

#
# Check
# 
Write-Host "---"
Write-Host "package.json:"
Write-Host $json
