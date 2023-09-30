#!/bin/bash

# Configure managed identities for Azure resources on an Azure VM using Azure CLI
# Source: https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/qs-configure-cli-windows-vm

# az login

az group create --name robazresourcegroup \
    --location eastus


az vm create --name myVM \
    --resource-group robazresourcegroup \
    --location eastus \
    --image win2016datacenter \
    --generate-ssh-keys \
    --admin-username azureuser \
    --admin-password myPassword12

# Assign a system-assigned managed identity
az vm identity assign -g robazresourcegroup -n myVM

# Assign a user-assigned managed identity
az identity create -g robazresourcegroup -n myUserAssignedIdentity
az vm identity assign -g robazresourcegroup -n myVM --identities myUserAssignedIdentity

# See removing here... and also disabling...
# https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/qs-configure-cli-windows-vm#remove-a-user-assigned-managed-identity-from-an-azure-vm

# Remove a system-assigned managed identity when there are no user-assigned managed identities present...
# az vm update -n myVM -g myResourceGroup --set identity.type="none"


## Can also apply to...
# az webapp identity assign -g MyResourceGroup -n MyUniqueApp --role reader --scope /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/MyResourceGroup
# az functionapp identity assign -g MyResourceGroup -n MyUniqueApp --role reader --scope /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/MyResourceGroup

az vm list --show-details --output table
