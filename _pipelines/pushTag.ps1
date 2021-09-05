param(
  [Parameter(Mandatory=$true)]
  $versionParameter
  ,
  [Parameter(Mandatory=$true)]
  $tagParameter
)

# Add TAG
git tag -a $tagParameter -m "Tag for build $versionParameter"

# Push TAG
git push origin $tagParameter