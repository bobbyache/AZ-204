# Create an Azure Cosmos DB resources by using the Azure CLI

- [Create an Azure DB account](https://learn.microsoft.com/en-us/training/modules/explore-azure-cosmos-db/8-create-cosmos-db-resources-portal)
- [Work with Azure Cosmos DB](https://learn.microsoft.com/en-us/training/modules/work-with-cosmos-db/)

- [Explore CosmosDB various NoSQL engines (using JavaScript)](https://app.exampro.co/student/material/az-204/2663)

> **Hint:** Look for the Quick Start area to download samples in your language.


# Cosmos DB ToDo App

- [Code Samples: Cosmos DB Todo App](https://www.udemy.com/course/70532-azure/learn/lecture/14210062#overview)

# Cosmos Client

Course: AZ-204
Main Topic: Develop for Azure storage
Section: Develop solutions that use Azure Cosmos DB

You can get the test app (.NET Core 3.1) from this repository.

```bash
git clone https://github.com/Azure-Samples/cosmos-dotnet-core-todo-app.git
```

# Azure CLI

---

To deploy an ARM template with [Azure CLI look here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-cli)

Get help with the [Azure Command-Line Interface](https://learn.microsoft.com/en-us/cli/azure/) (CLI) documentation

For help with usage of JMESPath look [here](https://jmespath.org/examples.html) and [here](https://learn.microsoft.com/en-us/cli/azure/query-azure-cli?tabs=concepts%2Cbash).

### Locations

`az account list-locations` will give you a list of locations you can choose from. Try this one to be less verbose: `az account list-locations --query "[].name"` or even this one `az account list-locations --query "[].{ name: name, displayName: displayName }"`.

Find resource groups with a specific name…

```bash
az group list --query "[?contains(name, 'rob')].{ name: name, id: id }"
```

## Create a Cosmos DB Account

Use Shift + Enter to enter multi-line statements at the command-line. Note these multi-line statements only work in Git Bash. In order to have multi-line statements in PowerShell use the back tick.

```bash
az login

# Create resource group
az group create --name robazresourcegroup --location southafricanorth

# Check if account exists
az cosmosdb check-name-exists --name robazcosmosdbaccount

# Create the Cosmos DB account
az cosmosdb create \
	--name robazcosmosdbaccount \
	--resource-group robazresourcegroup \
	--enable-free-tier true \
	--tags department=accounting tags.owner=cygsoft

# Create a Cosmos DB (no)SQL database
az cosmosdb sql database exists \
	--name Tasks \
	--account-name robazcosmosdbaccount \
	--resource-group robazresourcegroup

az cosmosdb sql database create \
	--name Tasks \
	--account-name robazcosmosdbaccount \
	--resource-group robazresourcegroup \
	--throughput 400
```

If you want to enable serverless you’ll use this: `--capabilities EnableServerless`. Look [here](https://learn.microsoft.com/en-us/azure/cosmos-db/scripts/cli/nosql/serverless#run-the-script) for create as serverless, [here](https://learn.microsoft.com/en-us/azure/cosmos-db/scripts/cli/nosql/autoscale) for create with auto scale, and [here](https://learn.microsoft.com/en-us/azure/cosmos-db/scripts/cli/nosql/throughput) for throughput.

```bash
# Create a container (collection, table)
az cosmosdb sql container exists \
	--name Item \
	--database-name Tasks \
	--account-name robazcosmosdbaccount \
	--resource-group robazresourcegroup

az cosmosdb sql container create \
	--name Item \
	--database-name Tasks \
	--throughput 400 \
	--account-name robazcosmosdbaccount \
	--resource-group robazresourcegroup \
	--partition-key-path '//id'
```

Partition Key Path, e.g., '/properties/name’. Note to escape the `/` do it twice (in bash).

```bash
# List the connection strings you can use to connect.
# connection-strings, keys, read-only-keys
az cosmosdb keys list \
	--name robazcosmosdbaccount \
	--resource-group robazresourcegroup \
	--type keys

# You'll also need the endpoint of your newly created Cosmos DB Account
az cosmosdb show \
	--name robazcosmosdbaccount \
	--resource-group robazresourcegroup \
	--query documentEndpoint
```

### Build an Application that talks to the database

You can get the test app (.NET Core 3.1) from this repository.

```bash
git clone https://github.com/Azure-Samples/cosmos-dotnet-core-todo-app.git
```

Using the primary key and the account URI one can connect the sample application and experiment with the code. You should store database settings such as account and key as [environment variables in PowerShell](https://learn.microsoft.com/en-us/training/paths/develop-solutions-that-use-blob-storage/).

```bash
{
  "Logging": {
    "LogLevel": {
      "Default": "Warning"
    }
  },
  "AllowedHosts": "*",
  "CosmosDb": {
    "Account": "https://robazcosmosdbaccount.documents.azure.com:443/",
    "Key": "RHpcA1...==",
    "DatabaseName": "Tasks",
    "ContainerName": "Item"
  }
}
```

- [x]  Get the connection string for the database (or collection)

For database operations there is a [resource](https://github.com/Krumelur/AzureScripts) of scripts that is being collected.

- [ ]  Populate with some dummy data ([here is an example](https://github.com/Krumelur/AzureScripts/blob/master/cosmosdb_create_document.sh) of how to use this and [here](https://stackoverflow.com/questions/61426902/use-bash-azure-cli-and-rest-api-to-access-cosmosdb-how-to-get-token-and-hash) is an explanation of how it is used)

```bash
curl --request $verb --data "@$documentJson" -H "x-ms-documentdb-is-upsert: $isUpsert" -H "x-ms-documentdb-partitionkey: [\"default\"]" -H "x-ms-date: $now" -H "x-ms-version: 2018-12-31" -H "Content-Type: application/json" -H "Authorization: $urlEncodedAuthString" $url
```

## Cleaning up

```bash
az cosmosdb collection delete --collection-name Tasks --name robazcosmosdbaccount --resource-group robazresourcegroup
az cosmosdb database delete --name robazcosmosdbaccount --resource-group robazresourcegroup
az cosmosdb delete --name robazcosmosdbaccount --resource-group robazresourcegroup

az group delete --name robazresourcegroup
```