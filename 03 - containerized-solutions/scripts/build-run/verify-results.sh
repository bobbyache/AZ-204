#!/bin/bash

# Source:
# Exercise: Build and run a container image by using Azure Container Registry Tasks
# https://learn.microsoft.com/en-us/training/modules/publish-container-image-to-azure-container-registry/6-build-run-image-azure-container-registry

resourceGroup=robaz-acr-resourcegroup
containerRegistry=robazacrregistry
location=eastus

# az login

az acr repository show-tags --name $containerRegistry \
    --repository sample/hello-world --output table