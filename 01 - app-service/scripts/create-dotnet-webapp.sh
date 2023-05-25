#!/bin/bash

# Log in to Azure
# az login

# Define variables
num=$RANDOM
resourceGroup="robazresourcegroup$RANDOM"
appServicePlan="robazappserviceplan$RANDOM"
appName="robazfreedotnetwebapp$RANDOM"
location="eastus"  # e.g., westus


# Set the active subscription
subscriptionId=$(az account show --subscription "" --query id --output tsv)
az account set --subscription $subscriptionId

# Create a resource group
az group create --name $resourceGroup --location $location

# Create an app service plan
az appservice plan create --resource-group $resourceGroup \
    --name $appServicePlan --sku B1 --is-linux 
    # --tags owner=rob env=staging

# Create the web app
# Do a "az webapp list-runtimes --os-type Linux" to list available runtimes
az webapp create --resource-group $resourceGroup --name $appName \
    --plan $appServicePlan \
    --runtime "DOTNETCORE:6.0"

# Stream logs in your App Service
az webapp log tail --name $appName --resource-group $resourceGroup

# # Clean up temporary files
# az logout
