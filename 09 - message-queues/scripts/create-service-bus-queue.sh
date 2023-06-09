#!/bin/bash

myLocation=eastus
myResourceGroup=robazresourcegroup
myNamespaceName=robazservicebus$RANDOM

az login

az group create --name $myResourceGroup --location $myLocation

az servicebus namespace create \
    --resource-group $myResourceGroup \
    --name $myNamespaceName \
    --location $myLocation

az servicebus queue create \
    --resource-group $myResourceGroup \
    --namespace-name $myNamespaceName \
    --name az204-queue

# az group delete --name $myResourceGroup --no-wait
