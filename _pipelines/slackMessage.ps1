param(
  [Parameter(Mandatory=$true)]
  $slackHookUri
  ,
  [Parameter(Mandatory=$true)]
  $slackAzureProjectBuildUri
  ,
  [Parameter(Mandatory=$true)] # Azure resource name, or app name
  $resourceName
  ,
  [Parameter(Mandatory=$true)] # Azure $(Agent.JobStatus): Canceled | Failed | Succeeded | SucceededWithIssues
  $status
  ,
  #
  # In case of failures, these params might not be avail:
  #
  [Parameter(Mandatory=$false)]
  $buildEnvironmentName
  ,
  [Parameter(Mandatory=$false)]
  $buildVersionNumber
)

Write-Host "---"
Write-Host "Slack if necessary..."

# List parameters...
# Get-Variable -Scope Private
# $MyInvocation.MyCommand.Parameters | Format-Table -AutoSize @{ Label = "Key"; Expression={$_.Key}; }, @{ Label = "Value"; Expression={(Get-Variable -Name $_.Key -EA SilentlyContinue).Value}; }
# (Get-Command -Name $PSCommandPath).Parameters | Format-Table -AutoSize @{ Label = "Key"; Expression={$_.Key}; }, @{ Label = "Value"; Expression={(Get-Variable -Name $_.Key -EA SilentlyContinue).Value}; }

function Send-SlackMessage {
    param (
        [Parameter(Mandatory=$true, Position=0)]$uri,
        [Parameter(Mandatory=$true, Position=1)]$body
    )

    # $body= @"
    # {
    #     "username": "Loading Bay",
    #     "text": "MESSAGE_TEXT",
    #     "icon_emoji":":rolled_up_newspaper:"
    # }
    # "@

    Invoke-WebRequest -Method Post -Uri $uri -Body $body -ContentType 'application/json'
}

#
# set status text and icon
# $status = Azure $(Agent.JobStatus): Canceled | Failed | Succeeded | SucceededWithIssues
#

$text = "Deployment of *$($resourceName.ToUpper())* on *$($buildEnvironmentName.ToUpper())* environment with version $buildVersionNumber *$($status.ToUpper())*"

switch("$status") {
  "Failed" { $icon = ":collision:" }
  "Succeeded" { $icon = ":heavy_check_mark:" }
  "SucceededWithIssues" { $icon = ":grey_question:" }
  "Cancelled" { $icon = ":heavy_multiplication_x:" }
  default { $icon = ":question:" }
}

Write-Host "Text: $text"
Write-Host "Icon: $icon"

# NOTE: 1st condition: $TRUE = always send message, $FALSE = filter which messages to send (failures and all PROD messages)
if ( $TRUE -or ($buildEnvironmentName -eq "PROD") -or ($status -in @("Failed", "SucceededWithIssues")) ) {

  $body = @{

    blocks = @(

      @{
        type = "section"
        text = @{
          type = "mrkdwn"
          text = "$icon`n$text"
        }
      }

      @{
        type = "section"
        text = @{
          type = "mrkdwn"
          text = "Deployment log link:`n$slackAzureProjectBuildUri"
        }
      }

    )

    # NOTE: the username and icon (assigned to user) won't be displayed on consecutive published messages (just on the 1st one)
    username = "Azure pipeline"
    icon_emoji = ":spider_web:"

    # NOTE: we use markdown and blocks for rich formatting (and thus then text seems to be ignored)
    # text = "> $text"
  }

  $json = $body | ConvertTo-Json -Depth 10

  Write-Host "---"
  Write-Host "Slacking with body: $json"

  Send-SlackMessage $slackHookUri $json

} else {

  Write-Host "---"
  Write-Host "Slack notification not necessary..."

}
