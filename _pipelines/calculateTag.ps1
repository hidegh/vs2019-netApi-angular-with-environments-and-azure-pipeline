param(
  [Parameter(Mandatory=$true)]
  [string]$versionParameter
  ,
  [Parameter(Mandatory=$false)]
  [string]$prefix
  ,
  [Parameter(Mandatory=$false)]
  [string]$suffix
)

Write-Host "---"
Write-Host "Calculating new tag, setting into: 'env:buildVersionTag'"

Write-Host "Build version: $versionParameter"
Write-Host "Prefix       : $prefix"
Write-Host "Suffix       : $suffix"

$newVersionTag = $versionParameter;
  
if (![string]::IsNullOrWhiteSpace($prefix)) {
  $newVersionTag = $prefix + $newVersionTag
}

if (![string]::IsNullOrWhiteSpace($suffix)) {
  $newVersionTag = $newVersionTag + $suffix
}

Write-Host "New TAG: $newVersionTag"

# This is for setting GA env. variable
# echo "::set-env name=buildVersionTag::$newVersionTag"

# This is for setting Azure pipeline variable
Write-Host "##vso[task.setvariable variable=buildVersionTag]$newVersionTag"

Write-Host "Environment variable: 'buildVersionTag' was set"
