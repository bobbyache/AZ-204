
#!/bin/bash

# Source: https://learn.microsoft.com/en-us/training/modules/azure-event-grid/8-event-grid-custom-events

# Set up variables
let rNum=$RANDOM*$RANDOM
myResourceGroup=robazresourcegroup
myLocation=eastus
myTopicName="robaz-egtopic-${rNum}"
mySiteName="robaz-egsite-${rNum}"
mySiteUrl="https://${mySiteName}.azurewebsites.net"

# Login
# az login

# ------------------------------------------------------------------------------------------------------------------------------
# Enable an Event Grid Resource Provider
# ------------------------------------------------------------------------------------------------------------------------------
if [[ "$(az provider show --namespace Microsoft.EventGrid --query registrationState --output tsv)" != "Registered" ]]; then
    az provider register --namespace Microsoft.EventGrid
fi

# ------------------------------------------------------------------------------------------------------------------------------
# Create an Event Topic
# ------------------------------------------------------------------------------------------------------------------------------

# Create a resource group
az group create --name $myResourceGroup --location $myLocation

# Create a custom topic
az eventgrid topic create --name $myTopicName \
    --location $myLocation \
    --resource-group $myResourceGroup

# ------------------------------------------------------------------------------------------------------------------------------
# Create a message endpoint

# Before subscribing to the custom topic, we need to create the endpoint for the event message.
# Typically, the endpoint takes actions based on the event data. 
# The following script uses a prebuilt web app that displays the event messages. 
# The deployed solution includes an App Service plan, an App Service web app, and source code from GitHub.
# It also generates a unique name for the site.
# ------------------------------------------------------------------------------------------------------------------------------

az deployment group create \
    --resource-group $myResourceGroup \
    --template-uri "https://raw.githubusercontent.com/Azure-Samples/azure-event-grid-viewer/main/azuredeploy.json" \
    --parameters siteName=$mySiteName hostingPlanName=viewerhost

# Navigate to this site URL to start monitoring events
echo "Your web app URL: ${mySiteUrl}"

# ------------------------------------------------------------------------------------------------------------------------------
# Note you can browse to https://raw.githubusercontent.com/Azure-Samples/azure-event-grid-viewer/main/azuredeploy.json
#    to view the JSON
# the deployed app is a site that displays events for Azure Event Grid in near real time:
#       https://github.com/Azure-Samples/azure-event-grid-viewer
# ------------------------------------------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------------------------------------------------------
# Subscribe an Event Topic
# ------------------------------------------------------------------------------------------------------------------------------    

endpoint="${mySiteUrl}/api/updates"
#subId=$(az account show --subscription "" | jq -r '.id')
subId=$(az account show --subscription "" --query id --output tsv)

# Never seems to work...
az eventgrid event-subscription create \
    --source-resource-id "/subscriptions/${subId}/resourceGroups/${myResourceGroup}/providers/Microsoft.EventGrid/topics/${myTopicName}" \
    --name az204ViewerSub \
    --endpoint $endpoint

# Retrieve URL and key from custom topic
topicEndpoint=$(az eventgrid topic show --name $myTopicName -g $myResourceGroup --query "endpoint" --output tsv)
key=$(az eventgrid topic key list --name $myTopicName -g $myResourceGroup --query "key1" --output tsv)

# Create the event data
event='[ {"id": "'"$RANDOM"'", "eventType": "recordInserted", "subject": "myapp/vehicles/motorcycles", "eventTime": "'`date +%Y-%m-%dT%H:%M:%S%z`'", "data":{ "make": "Contoso", "model": "Monster"},"dataVersion": "1.0"} ]'

# Use cURL to send the event to the topic
curl -X POST -H "aeg-sas-key: $key" -d "$event" $topicEndpoint

# Clean up
az group delete --name $myResourceGroup --no-wait 