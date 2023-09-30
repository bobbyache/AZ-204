
# Useful

```bash
# Create a random key
myKeyVault=robazkeyvlttest-$RANDOM

az login

# List resource groups that contain...
az group list --query "[?contains(name, 'rob')].{ name: name, id: id }"

myLocation=eastus
az group create --name az204-vault-rg34 --location $myLocation

# Don't wait, don't prompt...
az group delete --name az204-vault-rg34 --no-wait --yes

# # Get details for the current subscription
# az account list -o table # or
# az account show #note the "id" is the subscription id
# az account set --subscription a340a8e0-18f2-4355-bf29-beaad05b582e # try and switch account
```

To deploy an ARM template with [Azure CLI look here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-cli).

Get help with the [Azure Command-Line Interface](https://learn.microsoft.com/en-us/cli/azure/) (CLI) documentation

For help with usage of JMESPath look [here](https://jmespath.org/examples.html) and [here](https://learn.microsoft.com/en-us/cli/azure/query-azure-cli?tabs=concepts%2Cbash).

Use `Get-Command -AzResourceGroup` to find the commands for a specific item you might know something about. If we’re working with functions so a good strategy would be to `Get-Command New-AzFunc`.

To look at a file `cat ./javascriptfunc/index.js`.

### Locations

`az account list-locations` will give you a list of locations you can choose from. Try this one to be less verbose: `az account list-locations --query "[].name"` or even this one `az account list-locations --query "[].{ name: name, displayName: displayName }"`.

# Web Apps

```bash
# Create an app service plan
az appservice plan create --resource-group $resourceGroup \
    --name $appServicePlan --sku B1 --is-linux 

# Do a "az webapp list-runtimes --os-type Linux" to list available runtimes
az webapp create --resource-group $resourceGroup --name $appName \
    --plan $appServicePlan \
    --runtime "DOTNETCORE:6.0"
```

```bash
# Stream logs in your App Service
az webapp log tail --name $appName --resource-group $resourceGroup
```

```bash
az webapp up

mkdir htmlapp
cd htmlapp

git clone https://github.com/Azure-Samples/html-docs-hello-world.git

resourceGroup=$(az group list --query "[].{id:name}" -o tsv)
appName=az204app$RANDOM

az webapp up -g $resourceGroup -n $appName --html

# At this point if you're working on your local machine you can use `code .` to open the code
# Make a change to the code and redeploy using...
az webapp up -g $resourceGroup -n $appName --html
```
Look [here for examples](https://learn.microsoft.com/en-us/azure/app-service/samples-cli) of how to create an deploy web apps (including management of deployment slots) using  the Azure CLI.

Can retrieve a list of supported Linux runtimes using `az webapp list-runtimes --os-type linux`.

Deploying a Zip file using Kudu (behind the scenes)
```bash
# Azure CLI
az webapp deployment source config-zip --resource-group $resourcegroup --name $webapp --src clouddrive/filename.zip

#cURL
curl -x POST -u username --data-binary @"./zipfile.zip" https://appname.scm.azurewebsites.net/api/zipdeploy
```

### Enable Client Certificates

```bash
az webapp update --set clientCertEnabled=true --name <app-name> --resource-group <group-name>
```

# Containers

```bash
az container create \
    --resource-group $resourcegroup \
    --file env.yaml \
```

```bash
az webapp create \
    --name $webApp \
    --resource-group $resourceGroup \
    --plan $appServicePlan  \
    --deployment-container-image-name $image
```

```bash
az container create \
    --resource-group $resourcegroup \
    --name hellofiles \
    --image mcr.microsoft.com/azuredocs/aci-hellofiles \
    --dns-name-label $hellofiles \
    --ports 80 \
    --azure-file-volume-account-name $funcappstorage \
    --azure-file-volume-account-key $KEY \
    --azure-file-volume-share-name $filehare \
    --azure-file-volume-mount-path /aci/logs/
```

```bash
az container show --resource-group $resourcegroup \
    --name $securetest \
    --query "containers[0].environmentVariables"

az container show --resource-group $resourcegroup \
  --name hellofiles --query ipAddress.fqdn --output tsv
```

# Container Apps

```
az containerapp env create ...

```

# Azure Functions

`az functionapp list-consumption-locations` will allow you to list all the consumption locations you can choose.

Supported runtimes: `az functionapp list-runtimes --os-type windows --query "[].runtime"`.

When creating a local function app and adding functions to it you’ll have to use Azure Functions Core Tools.

- `func start` will start your function for debugging.

To set up Azure Function Core Tools you can use these commands to add functions globally. If you can’t find the tools installed globally in npm using npm list -g change your node version to 16 using nvm.

```bash
npm list -g # deprecated
npm list --location=global

npm uninstall -g azure-functions-core-tools
npm install -u -g azure-functions-core-tools@4
npm install -u -g azure-functions-core-tools@3

npm list -g # deprecated
npm list --location=global
```

### Bash
```bash
az functionapp create \
    --name $netfncapp \
    --resource-group $resourceGroup \
    --location $location \
    --storage-account $netfncstorage \
    --runtime dotnet \
    --runtime-version 6 \
    --functions-version 4 \
    --os-type Windows
```

```bash
az functionapp create \
    --name $nodefncapp \
    --resource-group $resourceGroup \
    --location $location \
    --storage-account $nodefncstorage \
    --runtime node \
    --runtime-version 16 \
    --functions-version 4 \
    --os-type Windows
```
### Publish using Tools
```bash
func init --worker-runtime dotnet --source-control false
func new --name csharpfunc --language "C#" --template "HTTP trigger" --authlevel anonymous
func azure functionapp publish $netfncapp
```

```bash
func init --worker-runtime node --language javascript --source-control false
func new --name javascriptfunc --language javascript --template "HTTP trigger" --authlevel anonymous --model V3

# Build and start the function running locally.
npm i
npm run build
npm start

func azure functionapp publish $nodeApp
```

```bash
# Can test it in another terminal (if you do a "func start" you may not need need another terminal)
curl http://localhost:7071/api/javascriptfunc
```

# Managed Identity

- [Managed Identity Deep Dive Examples](https://github.com/johnthebrit/RandomStuff/blob/master/ManagedIdentity/mngIdDD.md#managed-identity-demonstration)

A user-assigned identity is always created independent of the resource is to give identity. 
```bash
az vm identity assign -g $resourcegroup -n myVM

# Create a user-assigned identity
az identity create -g $resourcegroup -n myUserAssignedIdentity
az vm identity assign -g $resourcegroup -n myVM --identities myUserAssignedIdentity
```
also
```bash
az webapp identity assign \
    -g MyResourceGroup \
    -n MyUniqueApp \
    --role reader \
    --scope /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/MyResourceGroup
```
and even...
```
az appconfig identity assign \ 
    --name myTestAppConfigStore \ 
    --resource-group myResourceGroup
```

`az ad app list --query [].displayName` to list all app registrations.
This query gets a list of all managed identities defined in the subscription.
```bash
az ad sp list --query "[?servicePrincipalType == 'ManagedIdentity']" --all
# or
az ad sp list --query "[?servicePrincipalType == 'ManagedIdentity'].{ displayName: displayName, appId: appId }" --all
```

```bash
# Give the user-defined managed identity access to the resource
az role assignment create \
    --assignee $identityClientId \
    --role $roleName \
    --scope "/subscriptions/<subscription_id>/resourceGroups/$resourceGroup/providers/Microsoft.<resource_type>/$storageAccount"
```
Assigning an identity to App Configuration.
```bash
# system assigned managed identity
az appconfig identity assign \ 
    --name myTestAppConfigStore \ 
    --resource-group myResourceGroup

# user assigned managed identity
az identity create --resource-group myResourceGroup --name myUserAssignedIdentity

az appconfig identity assign --name myTestAppConfigStore \ 
    --resource-group myResourceGroup \ 
    --identities /subscriptions/[subscription id]/resourcegroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUserAssignedIdentity
```
To create, enable an Azure virtual machine (or other resource) with the system-assigned managed identity your account needs the Virtual Machine Contributor role assignment. No other Azure AD directory role assignments are required.

```bash
az group create --name $resourcegroup --location eastus

# You couldn't get this to work on creation (System-Assigned)
# ... however it does seem to work after creation with "vm identity assign..."
az vm create --resource-group $resourcegroup --location eastus --name myVM --image win2016datacenter --generate-ssh-keys --admin-username azureuser --admin-password myPassword12 \
    # --assign-identity --role Contributor --scope "/subscriptions/ca5d6b8a-b966-4534-882c-65db19cd968d/resourceGroups/testrobazresourcegroup"  <-- couldn't get this to work...
az vm identity assign -g $resourcegroup -n myVM

# (User Assigned)
az identity create -g $resourcegroup -n myUserAssignedIdentity
az vm identity assign -g $resourcegroup -n myVM --identities myUserAssignedIdentity


az vm list --show-details --output table

# az group delete --name $resourcegroup
```

# Key Vaults

```bash
az keyvault create --name $myKeyVault --resource-group az204-vault-rg --location $myLocation
```

```bash
az keyvault secret set --vault-name $myKeyVault --name "ExamplePassword" --value "hVFkk965BuUv"
```

```bash
az keyvault secret show --name "ExamplePassword" --vault-name $myKeyVault
```

## Rest
```
GET https://[robaz.vault.azure.net].vault.azure.net/secrets/ExamplePassword/versions?api-version=7.0&maxresults=25&_=1686...  HTTP/1.1 

Authorization: Bearer eyJ0eXAiOiJKV1...
```

# Blob Storage

```bash
az storage account create \
    --name $storageAccount \
    --location $location \
    --resource-group $resourceGroup \
    --sku Standard_LRS

az storage container list --connection-string "DefaultEndpointsProtocol=https;AccountName=robazstorage..."
```

### Managing Blobs over REST

```
curl -i -H "x-ms-version: 2019-12-12" -H "accept:application/json" \
"https://rob.blob.core.windows.net/containerName?restype=container&comp=list&SASToken" \
    --verbose
```

### Set  Lifecycle Policies

Create a file called `policy.json` and define it as such.

```json
{
    "rules": [
      {
        "enabled": true,
        "name": "move-to-cool",
        "type": "Lifecycle",
        "definition": {
          "actions": {
            "baseBlob": {
              "tierToCool": {
                "daysAfterModificationGreaterThan": 30
              }
            }
          },
          "filters": {
            "blobTypes": [
              "blockBlob"
            ],
            "prefixMatch": [
              "sample-container/log"
            ]
          }
        }
      }
    ]
  }
```
Now once the account has been created you can upload the lifecycle policy to the storage account. Partial updates are not supported. Lifecycle policy management must be written in full.
```bash
# A lifecycle management policy must be read or written in full.
# Partial updates are not supported.
# This will work on the current directory.
az storage account management-policy create `
	--account-name $storageaccount `
	--policy .\policy.json `
	--resource-group $resourcegroup
```

# Cosmos DB
- [Source Content](https://learn.microsoft.com/en-us/training/modules/work-with-cosmos-db/3-exercise-work-cosmos-db-dotnet)

```bash
# Create a Cosmos DB database with a container
az cosmosdb sql database create \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --name $databaseName
```
```bash
az cosmosdb sql container create \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --database-name $databaseName \
  --name $containerName \
  --partition-key-path $partitionKeyPath
```
```bash
# Create a simple document in the container
az cosmosdb sql container create-item \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --database-name $databaseName \
  --container-name $containerName \
  --item @$documentId.json
```
```bash
# Update the document in the container
az cosmosdb sql container replace-item \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --database-name $databaseName \
  --container-name $containerName \
  --item-id $documentId \
  --partition-key-path $partitionKeyPath \
  --item @$documentId-updated.json
```
```bash
# Delete the document from the container
az cosmosdb sql container delete-item \
  --resource-group $resourceGroup \
  --account-name $cosmosAccountName \
  --database-name $databaseName \
  --container-name $containerName \
  --item-id $documentId \
  --partition-key-path $partitionKeyPath
```

```bash
# List the connection strings you can use to connect.
# connection-strings, keys, read-only-keys
az cosmosdb keys list \
	--name $cosmosdbaccount \
	--resource-group $resourcegroup \
	--type keys

# You'll also need the endpoint of your newly created Cosmos DB Account
az cosmosdb show \
	--name $cosmosdbaccount \
	--resource-group $resourcegroup \
	--query documentEndpoint
```
Retrieve the primary key
```bash
az cosmosdb keys list --name $cosmosdbaccount --resource-group $resourcegroup
```

# Purge CDN Content

You can purge content in several ways.
- 
- On an endpoint by endpoint basis, or all endpoints simultaneously should you want to update everything on your CDN at once.
- Specify a file, by including the path to that file or all assets on the selected endpoint by checking the Purge All checkbox in the Azure portal.
- Based on wildcards (*) or using the root (/).

```bash
az cdn endpoint purge \
    --content-paths '/css/*' '/js/app.js' \
    --name ContosoEndpoint \
    --profile-name DemoProfile \
    --resource-group ExampleGroup
```

You can also preload assets into an endpoint. This is useful for scenarios where your application creates a large number of assets, and you want to improve the user experience by prepopulating the cache before any actual requests occur:

```bash
az cdn endpoint load \
    --content-paths '/img/*' '/js/module.js' \
    --name ContosoEndpoint \
    --profile-name DemoProfile \
    --resource-group ExampleGroup
```

# Redis

```bash
# Create Redis cache (capacity in Gigabytes)
az redis create \
  --name $redisCacheName \
  --resource-group $resourceGroup \
  --location $location \
  --sku $sku \
  --vm-size $vmSize
```

## Redis Command-line

- [Source Content](https://learn.microsoft.com/en-us/training/modules/develop-for-azure-cache-for-redis/3-configure-azure-cache-redis)
```bash
# Ping the server. Returns "PONG".
ping

# Sets a key/value in the cache. Returns "OK" on success.
set [key] [value]

# Gets a value from the cache.
get [key]

# Returns '1' if the key exists in the cache, '0' if it doesn't.
exists [key]

# Returns the type associated to the value for the given key.
type [key]

# Increment the given value associated with key by '1'. The value must be an integer or double value. This returns the new value.
incr [key]

# Increment the given value associated with key by the specified amount. The value must be an integer or double value. This returns the new value.
incrby [key] [amount]

# Deletes the value associated with the key.
del [key]

# Delete all keys and values in the database.
flushdb
```

When the TTL elapses, the key is automatically deleted, exactly as if the DEL command were issued. Information about expires are replicated and persisted on disk, the time virtually passes when your Redis server remains stopped (this means that Redis saves the date when a key expires).

```bash
expire counter 5
```

# Service Bus

```bash
az servicebus namespace create \
    --resource-group $myResourceGroup \
    --name $myNamespaceName \
    --location $myLocation

az servicebus queue create \
    --resource-group $myResourceGroup \
    --namespace-name $myNamespaceName \
    --name az204-queue
```

# Event Grid

```bash
# Create a custom topic
az eventgrid topic create --name $topic \
    --location $location \
    --resource-group $resourceGroup
```

# Event Hubs

```bash
az eventhubs namespace create \
    --name $namespaceName \
    --resource-group $resourceGroup \
    --sku Standard

az eventhubs eventhub create \
    --name $eventhubName \
    --resource-group $resourceGroup \
    --namespace-name $namespaceName \
    --partition-count 1 \
    --enable-capture true \
    --capture-interval 300 \
    --capture-size-limit 10485763 \
    --storage-account $storageAccount \
    --blob-container $blobContainerName
```

# API Management
- [Source](https://learn.microsoft.com/en-us/training/modules/explore-api-management/8-exercise-import-api)
Create an APIM instance. The `--sku-name` Consumption option is used to speed up the process for the walkthrough.

```bash
az apim create -n $myApiName \
    --location $myLocation \
    --publisher-email $myEmail  \
    --resource-group az204-apim-rg \
    --publisher-name AZ204-APIM-Exercise \
    --sku-name Consumption
```

### Stored Access Policies

```bash
az storage container policy create \
    --name <stored access policy identifier> \
    --container-name <container name> \
    --start <start time UTC datetime> \
    --expiry <expiry time UTC datetime> \
    --permissions <(a)dd, (c)reate, (d)elete, (l)ist, (r)ead, or (w)rite> \
    --account-key <storage account key> \
    --account-name <storage account name> \
```

# App Settings Feature Management

Example in an `appsettings.json` file. Feature flags have two settings... on and off. See [here](https://learn.microsoft.com/en-us/training/modules/implement-azure-app-configuration/4-app-configuration-feature-management) for an overview.
```json
{
	"FeatureManagement": {
		"FeatureA": true,
		"FeatureB": false,
		"FeatureC": {
			"EnabledFor": [
				{
					"Name": "Percentage",
					"Parameters": {
						"Value": 50
					}
				}
			]
		}
	}
}
```