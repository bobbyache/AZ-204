# Set the resource group and web app name
$resourceGroup="robazresourcegroup"
$appServicePlanName="robaz-appserviceplan"
$apiAppName="robaz-imgapi"
$webAppName="robaz-webapi"
$storageAccountName="robazimgstore"

$location="eastus"

$apiUrl="https://$apiAppName.azurewebsites.net"

az login

az group create --name $resourceGroup --location $location

# Set the storage account SKU and kind
$sku="Standard_LRS"
$kind="StorageV2"

# Create the storage account
az storage account create `
    --resource-group $resourceGroup `
    --name $storageAccountName `
    --sku $sku `
    --kind $kind `
    --location $location

az storage container create -n "images" --account-name $storageAccountName

# Retrieve the first connection string
# Requires extension to be installed 'az extension add --name azure-cli-storage'
$dbConnection=(az storage account show-connection-string --name $storageAccountName --resource-group $resourceGroup --query "connectionString" --output tsv)

# Create the app service plan
$sku="F1"
az appservice plan create --name $appServicePlanName --resource-group $resourceGroup --sku $sku

# Create the web app and set the application setting name and value
$settingName="StorageConnectionString"
$settingValue = $dbConnection | ConvertTo-Json
az webapp create --resource-group $resourceGroup --name $apiAppName --plan $appServicePlanName
az webapp create --resource-group $resourceGroup --name $webAppName --plan $appServicePlanName

# Add the application setting
az webapp config appsettings set --resource-group $resourceGroup --name $apiAppName --settings "$settingName=$settingValue"
az webapp config appsettings set --resource-group $resourceGroup --name $webAppName --settings "ApiUrl=$apiUrl"

Set-Location -Path "C:\Code\azure\AZ-204-DevelopingSolutionsforMicrosoftAzure\Allfiles\Labs\01\Starter\API"
az webapp deployment source config-zip --resource-group $resourceGroup --src api.zip --name $apiAppName

Set-Location -Path "C:\Code\azure\AZ-204-DevelopingSolutionsforMicrosoftAzure\Allfiles\Labs\01\Starter\Web"
az webapp deployment source config-zip --resource-group $resourceGroup --src web.zip --name $webAppName

Set-Location -Path $PSScriptRoot

# Clean up
# az group delete --name $resourceGroup