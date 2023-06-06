#!/bin/bash

az group create --name robazresourcegroup --location eastus

az storage account create \
	--name robazfuncappstorage \
	--location southafricanorth \
	--resource-group robazresourcegroup \
	--sku Standard_LRS \
	--allow-blob-public-access false

az storage share create --account-name robazfuncappstorage --name robazfilehare

KEY=$(az storage account keys list --account-name robazfuncappstorage --resource-group robazresourcegroup --query "[0].value" --out table)

# Currently fails here... documentation here: https://learn.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files
# and here: https://learn.microsoft.com/en-us/training/modules/create-run-container-images-azure-container-instances/6-mount-azure-file-share-azure-container-instances
az container create \
    --resource-group robazresourcegroup \
    --name hellofiles \
    --image mcr.microsoft.com/azuredocs/aci-hellofiles \
    --dns-name-label robazhellofiles \
    --ports 80 \
    --azure-file-volume-account-name robazfuncappstorage \
    --azure-file-volume-account-key $KEY \
    --azure-file-volume-share-name robazfilehare \
    --azure-file-volume-mount-path /aci/logs/

az container show --resource-group robazresourcegroup \
  --name hellofiles --query ipAddress.fqdn --output tsv