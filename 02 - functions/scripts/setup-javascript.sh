#!/bin/bash

resourceGroup="robazresourcegroupjs2"
location="eastus"
storageAccount="robazjsfuncstorage"
funcApp="robazjavascriptfuncapp"
url="https://$funcApp.azurewebsites.net/api/csharpfunc?name=robbocop"

# Check if you're logged in to Azure
if [ -z "$(az account show --query user.name)" ]; then
  # If you're not logged in, perform az login
  az login
else
  # If you're logged in, display a message
  echo "You're already logged in to Azure as $(az account show --query user.name -o tsv)."
fi

# Create resource group and required standard SKU storage account
az group create --name $resourceGroup --location $location

az storage account create --name $storageAccount --location $location --resource-group $resourceGroup --sku Standard_LRS --allow-blob-public-access false

# Create the function app
az functionapp create --name $funcApp \
  --resource-group $resourceGroup \
  --consumption-plan-location $location \
  --storage-account $storageAccount \
  --runtime node \
  --runtime-version 16 \
  --functions-version 4 \
  --os-type Windows

# Use Azure Functions Core Tools to create an Http triggered functions.
## Important: flags are case sensitive
func init --worker-runtime node --language javascript --source-control
# func templates list
func new --name javascriptfunc --language javascript --template "HTTP trigger" --authlevel anonymous --model V3

# Build and start the function running locally.
npm i
npm run build
npm start

# Can test it in another terminal (if you do a "func start" you may not need need another terminal)
curl http://localhost:7071/api/javascriptfunc

# Publish to the function app in Azure
func azure functionapp publish $funcApp

# Run the function and check it (az rest)
curl $url
