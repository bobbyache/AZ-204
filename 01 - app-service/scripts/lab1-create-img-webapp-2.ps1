# Set the resource group and web app name
$resourceGroup = "robazresourcegroup"
$appServicePlanName = "robaz-appserviceplan"
$apiAppName = "robaz-imgapi"
$webAppName = "robaz-webapi"
$storageAccountName = "robazimgstore"

$location = "eastus"

$apiUrl = "https://$apiAppName.azurewebsites.net"

Connect-AzAccount

New-AzResourceGroup -Name $resourceGroup -Location $location

# Set the storage account SKU and kind
$sku = "Standard_LRS"
$kind = "StorageV2"

# Create the storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -SkuName $sku -Kind $kind -Location $location

New-AzStorageContainer -Name "images" -Context $storageAccount.Context

# Retrieve the first connection string
$dbConnection = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).ConnectionString

# Create the app service plan
$sku = "F1"
New-AzAppServicePlan -Name $appServicePlanName -ResourceGroupName $resourceGroup -Location $location -SkuTier Free

# Create the web app and set the application setting name and value
$settingName = "StorageConnectionString"
$settingValue = ConvertTo-Json -InputObject $dbConnection
New-AzWebApp -ResourceGroupName $resourceGroup -Name $apiAppName -AppServicePlan $appServicePlanName
New-AzWebApp -ResourceGroupName $resourceGroup -Name $webAppName -AppServicePlan $appServicePlanName

# Add the application setting
Set-AzWebApp -ResourceGroupName $resourceGroup -Name $apiAppName -AppSettings @{"$settingName" = $settingValue}
Set-AzWebApp -ResourceGroupName $resourceGroup -Name $webAppName -AppSettings @{"ApiUrl" = $apiUrl}

Set-Location -Path "C:\Code\azure\AZ-204-DevelopingSolutionsforMicrosoftAzure\Allfiles\Labs\01\Starter\API"
Publish-AzWebapp -ResourceGroupName $resourceGroup -ArchivePath "api.zip" -Name $apiAppName

Set-Location -Path "C:\Code\azure\AZ-204-DevelopingSolutionsforMicrosoftAzure\Allfiles\Labs\01\Starter\Web"
Publish-AzWebapp -ResourceGroupName $resourceGroup -ArchivePath "web.zip" -Name $webAppName

Set-Location -Path $PSScriptRoot

# Clean up
# Remove-AzResourceGroup -Name $resourceGroup -Force
