# Set up variables
$rNum = (Get-Random) * (Get-Random)
$myResourceGroup = "robazresourcegroup"
$myLocation = "eastus"
$myTopicName = "robaz-egtopic-$rNum"
$mySiteName = "robaz-egsite-$rNum"
$mySiteUrl = "https://$mySiteName.azurewebsites.net"

# Login
# Connect-AzAccount

# ------------------------------------------------------------------------------------------------------------------------------
# Enable an Event Grid Resource Provider
# ------------------------------------------------------------------------------------------------------------------------------
$eventGridProvider = Get-AzProvider -Namespace Microsoft.EventGrid
if ($eventGridProvider.RegistrationState -ne "Registered") {
    Register-AzProvider -ProviderNamespace Microsoft.EventGrid
}

# ------------------------------------------------------------------------------------------------------------------------------
# Create an Event Topic
# ------------------------------------------------------------------------------------------------------------------------------

# Create a resource group
New-AzResourceGroup -Name $myResourceGroup -Location $myLocation

# Create a custom topic
New-AzEventGridTopic -ResourceGroupName $myResourceGroup -Name $myTopicName -Location $myLocation

# ------------------------------------------------------------------------------------------------------------------------------
# Create a message endpoint

# Before subscribing to the custom topic, we need to create the endpoint for the event message.
# Typically, the endpoint takes actions based on the event data. 
# The following script uses a prebuilt web app that displays the event messages. 
# The deployed solution includes an App Service plan, an App Service web app, and source code from GitHub.
# It also generates a unique name for the site.
# ------------------------------------------------------------------------------------------------------------------------------

$templateParams = @{
    "siteName" = $mySiteName
    "hostingPlanName" = "viewerhost"
}

New-AzDeployment -ResourceGroupName $myResourceGroup -TemplateUri "https://raw.githubusercontent.com/Azure-Samples/azure-event-grid-viewer/main/azuredeploy.json" -TemplateParameterObject $templateParams

# Navigate to this site URL to start monitoring events
Write-Host "Your web app URL: $mySiteUrl"

# ------------------------------------------------------------------------------------------------------------------------------
# Note you can browse to https://raw.githubusercontent.com/Azure-Samples/azure-event-grid-viewer/main/azuredeploy.json
#    to view the JSON
# the deployed app is a site that displays events for Azure Event Grid in near real time:
#       https://github.com/Azure-Samples/azure-event-grid-viewer
# ------------------------------------------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------------------------------------------------------
# Subscribe an Event Topic
# ------------------------------------------------------------------------------------------------------------------------------    

$endpoint = "$mySiteUrl/api/updates"
$subId = (Get-AzContext).Subscription.Id

# Never seems to work...
$eventGridTopicId = "/subscriptions/$subId/resourceGroups/$myResourceGroup/providers/Microsoft.EventGrid/topics/$myTopicName"

New-AzEventGridSubscription -EventSubscriptionName "az204ViewerSub" -Endpoint $endpoint -ResourceId $eventGridTopicId

# Retrieve URL and key from custom topic
$topic = Get-AzEventGridTopic -ResourceGroupName $myResourceGroup -Name $myTopicName
$topicEndpoint = $topic.Endpoint
$key = (Get-AzEventGridTopicKey -ResourceGroupName $myResourceGroup -Name $myTopicName).Key1

# Create the event data
$an_event = @(
    @{
        "id" = (Get-Random)
        "eventType" = "recordInserted"
        "subject" = "myapp/vehicles/motorcycles"
        "eventTime" = (Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz")
        "data" = @{
            "make" = "Contoso"
            "model" = "Monster"
        }
        "dataVersion" = "1.0"
    }
)

# Use Invoke-RestMethod to send the event to the topic
$headers = @{
    "aeg-sas-key" = $key
}
Invoke-RestMethod -Method Post -Uri $topicEndpoint -Headers $headers -Body ($an_event | ConvertTo-Json)

# Clean up
Remove-AzResourceGroup -Name $myResourceGroup -Force -AsJob
