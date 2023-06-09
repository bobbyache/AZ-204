$resourceGroup = "robazresourcegroup"
$location = "eastus"
$storageAccount = "robazstorageaccount"

# Check if you're logged in to Azure
if (-not (Get-AzContext -ErrorAction SilentlyContinue)) {
    # If you're not logged in, perform az login
    Connect-AzAccount
} else {
    # If you're logged in, display a message
    Write-Output "You're already logged in to Azure as $((Get-AzContext).Account)"
}

New-AzResourceGroup -Name $resourceGroup -Location $location

Write-Output "Creating storage account $storageAccount ..."
New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount -Location $location -SkuName Standard_LRS
Write-Output "Storage account $storageAccount created."

# Retrieve the first connection string - Requires module to be installed 'Install-Module -Name Az.Storage'
$dbConnection = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context.ConnectionString

Write-Output $dbConnection
