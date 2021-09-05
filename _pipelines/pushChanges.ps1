param(
  [Parameter(Mandatory=$true)]
  [string]$authorName
  ,
  [Parameter(Mandatory=$true)]
  [string]$authorEmail
  ,
  [Parameter(Mandatory=$true)]
  [string]$buildVersionNumber

)

# Fetch status
git status

# Set identity
git config user.name "$authorName" ; git config user.email "$authorEmail"

# Commit (--no-verify did not helped to prevent Azue CI to fire again)
git commit -a -m "[skip ci] Releasing $buildVersionNumber"

# Push - originally git push origin master
git push origin
