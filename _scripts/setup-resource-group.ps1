

$resourcePrefix = "robaz"
$resourceGroup =  $resourcePrefix + "resourcegroup"
$location = "eastus"
$vm1 = $resourcePrefix + "vm1"

$netfncstorage = $resourcePrefix + "dotnetfncstorage"
$netfncapp = $resourcePrefix + "dotnetfncapp"
$nodefncstorage = $resourcePrefix + "nodefncstorage"
$nodefncapp = $resourcePrefix + "nodefncapp"

$scriptFolder = $PSScriptRoot
$folderPath = "C:\Code\azure\temp\"

$storageAccount = $resourcePrefix + "stdstorageacc"

$cosmosDbAccount = $resourcePrefix + "cosmosdbacc"

$keyvault = $resourcePrefix + "stdkeyvault"

# Connect-AzAccount

# $Credential = Get-Credential
# Connect-AzAccount -Credential $Credential 

# (Get-AzContext).Account

New-AzResourceGroup -Name $resourceGroup -Location $location

<# .................................................
    Create a VM
................................................. #>
New-AzVM `
	-ResourceGroupName $resourceGroup `
	-Location $location `
	-Name $vm1 `
	-Credential (New-Object System.Management.Automation.PSCredential ('rob123', (ConvertTo-SecureString "9eERhs%zkhL7G4" -AsPlainText -Force))) `
	-PublicIPAddressName 'MyPublicIP' `
	-Size Standard_D2s_v3 `
	-OpenPort 80,443,3389


# <# .................................................
#     .NET Function App
#     - Build and publish functions
# ................................................. #>
# New-AzStorageAccount `
#     -Name $netfncstorage  `
#     -Location $location `
#     -ResourceGroupName $resourceGroup `
#     -SkuName Standard_LRS

# New-AzFunctionApp `
#     -Name $netfncapp `
#     -ResourceGroupName $resourceGroup `
#     -Location $location `
#     -StorageAccountName $netfncstorage `
#     -Runtime dotnet `
#     -RuntimeVersion 6 `
#     -FunctionsVersion 4 `
#     -OSType Windows

# New-AzStorageAccount `
#     -Name $nodefncstorage  `
#     -Location $location `
#     -ResourceGroupName $resourceGroup `
#     -SkuName Standard_LRS

# New-AzFunctionApp `
#     -Name $nodefncapp `
#     -ResourceGroupName $resourceGroup `
#     -Location $location `
#     -StorageAccountName $nodefncstorage `
#     -Runtime node `
#     -RuntimeVersion 16 `
#     -FunctionsVersion 4 `
#     -OSType Windows

# try {
#     # .NET
#     $dotnetFuncFolder = Join-Path -Path $folderPath -ChildPath "dotnetfunc"

#     if (-not (Test-Path $dotnetFuncFolder -PathType Container)) {
#         New-Item -ItemType Directory -Path $dotnetFuncFolder -Force | Out-Null
#         cd $dotnetFuncFolder
#         func init --worker-runtime dotnet --source-control false
#         func new --name csharpfunc --language "C#" --template "HTTP trigger" --authlevel anonymous
#         func azure functionapp publish $netfncapp
#         cd $folderPath
#         Remove-Item -Path $dotnetFuncFolder -Recurse -Force
#     }

#     # Node
#     $nodeFuncFolder = Join-Path -Path $folderPath -ChildPath "dotnetfunc"

#     if (-not (Test-Path $nodeFuncFolder -PathType Container)) {
#         New-Item -ItemType Directory -Path $nodeFuncFolder -Force | Out-Null
#         cd $nodeFuncFolder
#         func init --worker-runtime node --language javascript --source-control false
#         func new --name javascriptfunc --language javascript --template "HTTP trigger" --authlevel anonymous --model V3
#         npm i
#         npm build
#         func azure functionapp publish $nodefncapp
#         cd $folderPath
#         Remove-Item -Path $nodeFuncFolder -Recurse -Force
#     }

# } catch {
#   Write-Host "An error occurred:"
#   Write-Host $_.ScriptStackTrace
# } finally {
#     cd $scriptFolder
# }


# <# .................................................
#     Create a new standard storage account and
#     give it a lifecycle policy.
# ................................................. #>

# $storageAccRef = New-AzStorageAccount `
#     -Name $storageAccount `
#     -Location $location `
#     -ResourceGroupName $resourceGroup `
#     -SkuName Standard_LRS `
#     -AllowBlobPublicAccess $true

# $storageAccContext = $storageAccRef.Context

# # Create a policy life-cycle
# # See https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/storage/blobs/lifecycle-management-policy-configure.md for examples

# # Use the Azure CLI
# az storage account management-policy create --account-name $storageAccount `
#     --policy lifecycle-policy.json `
#     --resource-group $resourceGroup


# # Create a container and add some stuff...
# # https://learn.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-powershell

# $containername = 'quickstartblobs'

# New-AzStorageContainer -Name $containername -Context $storageAccContext -Permission Blob

# $solarpanels = @{
#     File = "./solar-panels.jpg"
#     Container = $containername
#     Blob = "solar-panels.jpg"
#     Context = $storageAccContext
#     StandardBlobTier = "Hot"
# }

# Set-AzStorageBlobContent @solarpanels

# <# .................................................
# Create a Cosmos DB account and database
# https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/manage-with-powershell
# ................................................. #>

# $apiKind = "Sql"
# $consistencyLevel = "BoundedStaleness"
# $maxStalenessInterval = 300
# $maxStalenessPrefix = 100000

# $locations = @()
# $locations += New-AzCosmosDBLocationObject -LocationName "East US" -FailoverPriority 0 -IsZoneRedundant 0
# $locations += New-AzCosmosDBLocationObject -LocationName "West US" -FailoverPriority 1 -IsZoneRedundant 0

# New-AzCosmosDBAccount `
#     -ResourceGroupName $resourceGroup `
#     -LocationObject $locations `
#     -Name $cosmosDbAccount `
#     -ApiKind $apiKind `
#     -EnableAutomaticFailover: $true `
#     -DefaultConsistencyLevel $consistencyLevel `
#     -MaxStalenessIntervalInSeconds $maxStalenessInterval `
#     -MaxStalenessPrefix $maxStalenessPrefix

# To Be continued....

# <# .................................................
# Create a new Key Vault
# https://www.modernendpoint.com/managed/Working-with-Azure-Key-Vault-in-PowerShell/#:~:text=After%20connecting%20to%20Azure%20powerShell,using%20the%20New%2DAzResourceGroup%20cmdlet.&text=After%20creating%20the%20resource%20group,using%20the%20New%2DAzKeyVault%20cmdlet.&text=Next%2C%20we%20can%20add%20a,using%20the%20Set%2DAzKeyVaultSecret%20cmdlet.
# ................................................. #>


# # Purging a soft deleted key vault https://learn.microsoft.com/en-us/azure/key-vault/general/soft-delete-overview#permitted-purge
# if ($null -ne (Get-AzKeyVault -VaultName $keyvault -InRemovedState -Location $location)) {
#     Remove-AzKeyVault -VaultName $keyvault -InRemovedState -Location $location -Force
# }

# New-AzKeyVault `
#     -Name $keyvault `
#     -ResourceGroupName $resourceGroup `
#     -Location $location

# $secretName = "MME-PS-Key" 
# $secretValue = "zPI7Q~ajN4xshSJfD_r.UdA1kf4ohEG8zGYgS" 

# # Add the secret to my vault
# $securedValue = ConvertTo-SecureString $secretValue -AsPlainText -Force
# $setSecret = Set-AzKeyVaultSecret -VaultName $keyvault -Name $secretName -SecretValue $securedValue

# Write-Host $setSecret
