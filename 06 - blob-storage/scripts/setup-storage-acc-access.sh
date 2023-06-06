#!/bin/bash

# Set the name and location of the resource group you want to create
resourceGroup="robazresourcegroup"
location="eastus"
storageAccount="robazstorageaccount"
identityName="myUserAssignedIdentity"
roleName="Contributor"

#!/bin/bash

# Check if you're logged in to Azure
if [ -z "$(az account show --query user.name)" ]; then
  # If you're not logged in, perform az login
  az login
else
  # If you're logged in, display a message
  echo "You're already logged in to Azure as $(az account show --query user.name -o tsv)."
fi

# Check if the resource group exists
if [ $(az group exists --name $resourceGroup) = false ]; then
  # If the resource group doesn't exist, create it
  echo "Creating resource group $resourceGroup ..."
  az group create --name $resourceGroup --location $location
  echo "Resource group $resourceGroup created."
else
  # If the resource group already exists, display a message
  echo "Resource group $resourceGroup already exists."
fi

echo "Creating storage account $storageAccount ..."
az storage account create \
    --name $storageAccount \
    --location $location \
    --resource-group $resourceGroup \
    --sku Standard_LRS
echo "Storage account $storageAccount created."

az identity create -g $resourceGroup -n $identityName


# Get the client ID of the user-defined managed identity
identityClientId=$(az identity show -g $resourceGroup -n $identityName --query "clientId" -otsv)

# Give the user-defined managed identity access to the resource
az role assignment create \
    --assignee "$identityClientId" \
    --role $roleName \
    --scope "/subscriptions/<subscription_id>/resourceGroups/$resourceGroup/providers/Microsoft.<resource_type>/$storageAccount"


