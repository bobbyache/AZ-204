#!/bin/bash

az group create --name robazresourcegroup --location eastus

az container create \
    --resource-group robazresourcegroup \
    --file env.yaml \

az container show --resource-group robazresourcegroup \
    --name robazsecuretest \
    --query "containers[0].environmentVariables"

curl robazcoolwebapp.eastus.azurecontainer.io

# az group delete --name robazresourcegroup --no-wait