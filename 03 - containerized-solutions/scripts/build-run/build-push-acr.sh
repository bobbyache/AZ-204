#!/bin/bash

# Source:
# Exercise: Build and run a container image by using Azure Container Registry Tasks
# https://learn.microsoft.com/en-us/training/modules/publish-container-image-to-azure-container-registry/6-build-run-image-azure-container-registry

resourceGroup=robaz-acr-resourcegroup
containerRegistry=robazacrregistry
location=eastus

az login

az group create --name $resourceGroup --location $location

az acr create --name $containerRegistry \
    --resource-group $resourceGroup --location $location \
    --sku Basic

echo FROM mcr.microsoft.com/hello-world > Dockerfile

az acr build --image sample/hello-world:v1 \
    --registry $containerRegistry \
    --file Dockerfile .
