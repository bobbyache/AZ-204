#!/bin/bash

# Source:
# Exercise - Deploy a container instance by using the Azure CLI
# https://learn.microsoft.com/en-us/training/modules/create-run-container-images-azure-container-instances/3-run-azure-container-instances-cloud-shell

resourceGroup=robazresourcegroup
container=robazcontainer
location=eastus

# az login

az group create --name $resourceGroup --location $location

DNS_NAME_LABEL=aci-example-$RANDOM

# Run container group and expose dns with ext. port
az container create --resource-group $resourceGroup \
    --name $container \
    --image mcr.microsoft.com/azuredocs/aci-helloworld \
    --dns-name-label $DNS_NAME_LABEL \
    --restart-policy OnFailure \
    --ports 80 \
    --cpu 1 \
    --memory 1

# Create a container with environment variables
az container create \
    --resource-group $resourceGroup \
    --name mywordcontainer \
    --image mcr.microsoft.com/azuredocs/aci-wordcount:latest \
    --restart-policy OnFailure \
    --environment-variables 'NumWords'='5' 'MinLength'='8'


az container show --resource-group $resourceGroup \
    --name $container \
    --query "{ FQDN:ipAddress.fqdn, ProvisioningState:provisioningState }" \
    --out table