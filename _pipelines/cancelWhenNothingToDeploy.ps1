param(
  [Parameter(Mandatory=$true)]
  [string]$authorName
  ,
  [Parameter(Mandatory=$true)]
  [string]$authorEmail
)

$lastCommitUser = git log -1 --pretty=format:'%an'

Write-Host "Last commit was made by: $lastCommitUser"

if ($lastCommitUser -eq $authorName) {
  Write-Error "This is just a SAFETY feature to abort the pipeline if the previous commit was made by the pipeline!"
}

