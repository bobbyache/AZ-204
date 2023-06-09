#!/bin/bash

# Set variables
resourceGroup="yourResourceGroup"
cosmosAccountName="yourCosmosAccountName"
databaseName="yourDatabaseName"
containerName="yourContainerName"
partitionKeyPath="/yourPartitionKeyPath"
documentId="yourDocumentId"

# Create a Cosmos DB database with a container
az cosmosdb sql database create \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --name $databaseName

az cosmosdb sql container create \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --database-name $databaseName \
  --name $containerName \
  --partition-key-path $partitionKeyPath

# Create a simple document in the container
az cosmosdb sql container create-item \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --database-name $databaseName \
  --container-name $containerName \
  --item @$documentId.json

# Update the document in the container
az cosmosdb sql container replace-item \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --database-name $databaseName \
  --container-name $containerName \
  --item-id $documentId \
  --partition-key-path $partitionKeyPath \
  --item @$documentId-updated.json

# Delete the document from the container
az cosmosdb sql container delete-item \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --database-name $databaseName \
  --container-name $containerName \
  --item-id $documentId \
  --partition-key-path $partitionKeyPath
