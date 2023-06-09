#!/bin/bash

resourceGroup="robazresourcegroup"
location="eastus"
storageAccount="robazstorageaccount"
location="eastus"

# Check if you're logged in to Azure
if [ -z "$(az account show --query user.name)" ]; then
  # If you're not logged in, perform az login
  az login
else
  # If you're logged in, display a message
  echo "You're already logged in to Azure as $(az account show --query user.name -o tsv)."
fi


az group create --name $resourceGroup --location $location

echo "Creating storage account $storageAccount ..."
az storage account create \
    --name $storageAccount \
    --location $location \
    --resource-group $resourceGroup \
    --sku Standard_LRS
echo "Storage account $storageAccount created."

# Retrieve the first connection string - Requires extension to be installed 'az extension add --name azure-cli-storage'
dbConnection=$(az storage account show-connection-string --name $storageAccount --resource-group $resourceGroup --query "connectionString" --output tsv)

echo $dbConnection