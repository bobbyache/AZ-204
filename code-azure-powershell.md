
# Useful

Get help with [Azure PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/azure/?view=azps-9.6.0) v9.6.0

Reference to Azure Functions Core Tools [at the command-line](https://learn.microsoft.com/en-us/azure/azure-functions/functions-core-tools-reference?tabs=v2). Here are some [full script examples](https://learn.microsoft.com/en-us/azure/azure-functions/create-resources-azure-powershell).

Use `Get-Command -AzResourceGroup` to find the commands for a specific item you might know something about. If we’re working with virtual machines so a good strategy would be to `Get-Command *-WebApp`.

```powershell
Connect-AzAccount
Disconnect-AzAccount

Get-Content csharpfunc.cs

# Create resource group and required standard SKU storage account
New-AzResourceGroup -Name robazresourcegroup -Location southafricanorth
Get-AzResource -ResourceGroupName robazresourcegroup | Format-Table
Get-AzResource -Name robazfuncappstorage -ResourceGroupName robazresourcegroup

Get-AzLocation | Format-Table Location, DisplayName
Get-AzLocation | Where-Object { $_.DisplayName -like "Canada" } | Format-Table Location, DisplayName

# Delete
Remove-AzResourceGroup -Name robazresourcegroup
```

```PowerShell
Get-Content .\typescriptfunc\index.ts
Get-AzResource -ResourceGroupName robazresourcegroup | Format-Table
Get-AzResource -Name robazfuncappstorage -ResourceGroupName robazresourcegroup
```

- [PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/azure/?view=azps-10.0.0&viewFallbackFrom=azps-9.6.0)

# Web Apps

```powershell
New-AzAppServicePlan -ResourceGroupName $resourceGroup -Name $appServicePlan -Location $location -Tier $sku -Linux
New-AzWebApp -ResourceGroupName $resourceGroup -Name $appName -AppServicePlan $appServicePlan
```

```powershell
# Stream logs in your App Service
Get-AzWebAppLogStreaming -Name $appName -ResourceGroupName $resourceGroup
```

```powershell
New-AzWebApp -Name $appName -ResourceGroupName $resourceGroup -TemplateFilePath "path/to/html_template.json"
```
Deploying a Zip file using Kudu (behind the scenes)
```powershell
Publish-AzWebApp -ResourceGroupName robazresourcegroup -name robazwebapp -ArchivePath "C:\code\contents.zip"
```

# Containers

```powershell
New-AzContainerGroup -ResourceGroupName $resourceGroup -File $envFile
```

```powershell
New-AzWebApp -Name $webApp `
    -ResourceGroupName $resourceGroup `
    -AppServicePlan $appServicePlan `
    -ContainerImageName $image
```

```powershell
# Create the Azure file share secret
$secret = ConvertTo-SecureString -String $storageAccountKey -AsPlainText -Force
$storageAccountCred = New-Object `
    -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $storageAccountName, $secret

# Create the container instance
New-AzContainerGroup `
    -ResourceGroupName $resourceGroup `
    -Name $name `
    -Image $image `
    -DnsNameLabel $dnsNameLabel `
    -Port $ports -AzureFileVolumeAccountName $storageAccountName `
    -AzureFileVolumeAccountKey $storageAccountCred `
    -AzureFileVolumeShareName $shareName `
    -AzureFileVolumeMountPath $mountPath
```

```powershell
# Get the container environment variables
$container = Get-AzContainerGroup -ResourceGroupName $resourceGroup -Name $containerName
$environmentVariables = $container.Containers[0].EnvironmentVariables
```

```powershell
$container = Get-AzContainerGroup -ResourceGroupName $resourceGroup -Name $containerName
$fqdn = $container.IPAddress.Fqdn
```


# Azure Functions

When creating a local function app and adding functions to it you’ll have to use Azure Functions Core Tools.

- `Get-Command New-AzFunc`.
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

### PowerShell

```powershell
New-AzFunctionApp `
    -Name $netfncapp `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -StorageAccountName $netfncstorage `
    -Runtime dotnet `
    -RuntimeVersion 6 `
    -FunctionsVersion 4 `
    -OSType Windows
```

```powershell
New-AzFunctionApp `
    -Name $nodefncapp `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -StorageAccountName $nodefncstorage `
    -Runtime node `
    -RuntimeVersion 16 `
    -FunctionsVersion 4 `
    -OSType Windows
```
### Publish using Tools

There isn't really anything in PowerShell... but you'll use the same commands for the Tools:

```bash
func init --worker-runtime dotnet --source-control false
func new --name csharpfunc --language "C#" --template "HTTP trigger" --authlevel anonymous
func azure functionapp publish $netfncapp
```

```bash
func init --worker-runtime node --language javascript --source-control false
func new --name javascriptfunc --language javascript --template "HTTP trigger" --authlevel anonymous --model V3
```

```bash
# Can test it in another terminal (if you do a "func start" you may not need need another terminal)
httprepl http://localhost:7071/api/javascriptfunc

```

# Managed Identity

```powershell
# Assign a system-assigned identity to the VM
Set-AzVM -ResourceGroupName $resourceGroup -VMName $vmName -AssignIdentity $true

# Create a user-assigned identity
$identity = New-AzUserAssignedIdentity -ResourceGroupName $resourceGroup -Name $identityName
# Assign the user-assigned identity to the VM
Set-AzVM -ResourceGroupName $resourceGroup -VMName $vmName `
    -Identity @(New-AzVmssIdentity `
    -UserAssignedIdentityId $identity.Id)
```

also

```powershell
# Give the user-defined managed identity access to the resource
# Assign the managed identity to the web app with the specified role and scope
$webApp = Get-AzWebApp -ResourceGroupName $resourceGroup -Name $appName
$roleAssignment = New-AzRoleAssignment `
    -ObjectId $webApp.Identity.PrincipalId `
    -RoleDefinitionName "Reader" `
    -Scope "/subscriptions/$subscriptionId/resourcegroups/$resourceGroup"
```
# Key Vaults

```powershell
New-AzKeyVault -VaultName $myKeyVault -ResourceGroupName "az204-vault-rg" -Location $myLocation
```

```powershell
Set-AzKeyVaultSecret -VaultName $myKeyVault -Name "ExamplePassword" -SecretValue "hVFkk965BuUv"
```

```powershell
Get-AzKeyVaultSecret -VaultName $myKeyVault -Name "ExamplePassword"
```

## Rest
```
GET https://[robaz.vault.azure.net].vault.azure.net/secrets/ExamplePassword/versions?api-version=7.0&maxresults=25&_=1686...  HTTP/1.1 

Authorization: Bearer eyJ0eXAiOiJKV1...
```

# Blob Storage

```powershell
New-AzStorageAccount `
    -Name $storageAccount `
    -Location $location `
    -ResourceGroupName $resourceGroup `
    -SkuName "Standard_LRS"
```

# Cosmos DB

```powershell
# Create a Cosmos DB database with a container
New-AzCosmosDBSqlDatabase -ResourceGroupName $resourceGroup `
    -AccountName $cosmosAccountName `
    -Name $databaseName
    
$container = New-AzCosmosDBSqlContainer -ResourceGroupName $resourceGroup `
    -AccountName $cosmosAccountName `
    -DatabaseName $databaseName `
    -Name $containerName `
    -PartitionKeyPath $partitionKeyPath
```

```powershell
# Create a simple document in the container
$document = Get-Content -Raw -Path $documentFilePath | ConvertFrom-Json
$container | Add-AzCosmosDBSqlContainerDocument -DocumentObject $document
```

```powershell
# Update the document in the container
$updatedDocument = Get-Content -Raw -Path $updatedDocumentFilePath | ConvertFrom-Json
$container | Update-AzCosmosDBSqlContainerDocument -DocumentId $documentId -PartitionKeyValue $document.$partitionKeyPath -DocumentObject $updatedDocument
```

```powershell
# Delete the document from the container
$container | Remove-AzCosmosDBSqlContainerDocument -DocumentId $documentId -PartitionKeyValue $document.$partitionKeyPath
```

# Purge CDN Content

You can purge content in several ways.
- 
- On an endpoint by endpoint basis, or all endpoints simultaneously should you want to update everything on your CDN at once.
- Specify a file, by including the path to that file or all assets on the selected endpoint by checking the Purge All checkbox in the Azure portal.
- Based on wildcards (*) or using the root (/).

# Redis

```powershell
# Create Redis cache (capacity in Gigabytes)
New-AzRedisCache -ResourceGroupName $resourceGroup -Name $redisCacheName -Location $location -Sku $sku -Size $vmSize

# Get Redis cache primary key
$redisCache = Get-AzRedisCache -ResourceGroupName $resourceGroup -Name $redisCacheName
$connectionString = $redisCache.RedisConfiguration.PrimaryKey

Write-Output "Azure Cache for Redis resource created successfully."
Write-Output "Connection string: $connectionString"
```

# Service Bus

```powershell
New-AzServiceBusNamespace `
    -ResourceGroupName $myResourceGroup `
    -Name $myNamespaceName `
    -Location $myLocation

New-AzServiceBusQueue `
    -ResourceGroupName $myResourceGroup `
    -NamespaceName $myNamespaceName `
    -Name "az204-queue"
```

# Event Grid

```powershell
# Create a custom topic
New-AzEventGridTopic -Name $topicName -Location $location -ResourceGroupName $resourceGroup
```

# Event Hubs

```powershell
# Create the Event Hubs namespace
New-AzEventHubNamespace -Name $namespaceName -ResourceGroupName $resourceGroup -Sku Standard

# Create the Event Hub
New-AzEventHub -Name $eventhubName -ResourceGroupName $resourceGroup -NamespaceName $namespaceName -PartitionCount $partitionCount -EnableCapture $enableCapture -CaptureIntervalInSeconds $captureInterval -CaptureSizeLimitInBytes $captureSizeLimit -StorageAccountName $storageAccount -CaptureContainerName $blobContainerName
```

# Api Management
- [Source Content](https://learn.microsoft.com/en-us/training/modules/explore-api-management/6-secure-access-api-subscriptions)
## Test API Keys
If key is not passed in header you'll get a 401 Access Denied response
```bash
curl --header "Ocp-Apim-Subscription-Key: <key string>" https://<apim gateway>.azure-api.net/api/path
```

```bash
curl https://<apim gateway>.azure-api.net/api/path?subscription-key=<key string>
```

# Microsoft Graph

- [Source Content](https://github.com/johnthebrit/RandomStuff/blob/master/AzureAD/MGAADDemo.ps1)
- [Video behind the content](https://youtu.be/bF8vkzXJsAY?t=1139) - Go back to look at this to get some idea of what everything below is all about if you have forgotten it.

This command should (if you're logged in) give you the token you can use to make the following REST call

```PowerShell
Connect-AzAccount
Connect-MgGraph

$accessToken = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com").Token
$accessToken
```

```PowerShell
$accessToken = (Get-AzAccessToken -ResourceUrl "https:/graph.microsoft.com").Token
$authHeader = @{
	'Content-Type'='application/json'
	'Authorization'='Bearer ' + @accessToken
}

$resp = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users/?`$filter=userType eq 'guest'" -Method GET -Headers $authHeader
```

Now using the Visual Studio Code REST Client extension you can get back details about yourself...
```
GET https://graph.microsoft.com/v1.0/me
Content-Type: application/json
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJub...
```

### Some other Code

```
Connect-AzAccount
Find-Module AzureAD*
Get-Command -Module Az.Resources -Noun AzAD*

Get-Help Get-AZADUser
Get-Help Get-AZADUser -Examples

Get-AZADUser | Format-Table UserPrincipalName, DisplayName -AutoSize
Get-AZADGroup | Format-Table DisplayName, Id -AutoSize

Get-AzADUser -Filter "startsWith(DisplayName, 'Rob')"
```