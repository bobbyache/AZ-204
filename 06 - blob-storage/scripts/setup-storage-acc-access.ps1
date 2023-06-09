# Set the name and location of the resource group you want to create
$resourceGroup = "robazresourcegroup"
$location = "eastus"
$storageAccount = "robazstorageaccount"
$identityName = "myUserAssignedIdentity"
$roleName = "Contributor"

# Check if you're logged in to Azure
if (-not (Get-AzContext)) {
    # If you're not logged in, perform Az login
    Connect-AzAccount
}
else {
    # If you're logged in, display a message
    $userName = (Get-AzContext).Account.Id
    Write-Host "You're already logged in to Azure as $userName."
}

# Check if the resource group exists
if (-not (Get-AzResourceGroup -Name $resourceGroup -ErrorAction SilentlyContinue)) {
    # If the resource group doesn't exist, create it
    Write-Host "Creating resource group $resourceGroup ..."
    New-AzResourceGroup -Name $resourceGroup -Location $location
    Write-Host "Resource group $resourceGroup created."
}
else {
    # If the resource group already exists, display a message
    Write-Host "Resource group $resourceGroup already exists."
}

Write-Host "Creating storage account $storageAccount ..."
New-AzStorageAccount -Name $storageAccount -Location $location -ResourceGroupName $resourceGroup -SkuName "Standard_LRS"
Write-Host "Storage account $storageAccount created."

New-AzUserAssignedIdentity -ResourceGroupName $resourceGroup -Name $identityName

# Get the client ID of the user-defined managed identity
$identity = Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroup -Name $identityName
$identityClientId = $identity.ClientId

# Give the user-defined managed identity access to the resource
$subscriptionId = "<subscription_id>"
$storageAccountResourceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Storage/storageAccounts/$storageAccount"
New-AzRoleAssignment -ObjectId $identityClientId -RoleDefinitionName $roleName -Scope $storageAccountResourceId
