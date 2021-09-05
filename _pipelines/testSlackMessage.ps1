.\slackMessage.ps1 `
-slackHookUri "https://hooks.slack.com/services/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" `
-slackAzureProjectBuildUri "https://dev.azure.com/impacthealth/teamlead/_build/results?buildId=007" `
-resourceName My-App `
-status Failed `
-buildEnvironmentName "qa" `
-buildVersionNumber "1.2.3.4"

# Status: Canceled | Failed | Succeeded | SucceededWithIssues