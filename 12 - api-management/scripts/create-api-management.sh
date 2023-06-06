#!/bin/bash

myApiName=robaz-apim-$RANDOM
myLocation=eastus
myEmail=robbie.a.blake@gmail.com

# Create a resource group
az group create --name robazresourcegroup --location eastus

az apim create -n $myApiName \
    --location $myLocation \
    --publisher-email $myEmail \
    --resource-group robazresourcegroup \
    --publisher-name robaz-apim-publisher
    --sku-name Consumption
