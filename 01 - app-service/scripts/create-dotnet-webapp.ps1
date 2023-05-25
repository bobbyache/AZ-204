# Log in to Azure
# Connect-AzAccount

# Define variables
$num = Get-Random
$resourceGroup = "robazresourcegroup$num"
$appServicePlan = "robazappserviceplan$num"
$appName = "robazfreedotnetwebapp$num"
$location = "eastus"  # e.g., westus
$sku = "B1"

# Set the active subscription
$subscriptionId = (Get-AzContext).Subscription.Id
Set-AzContext -SubscriptionId $subscriptionId

# Create a resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create an app service plan
New-AzAppServicePlan -ResourceGroupName $resourceGroup -Name $appServicePlan -Location $location -Tier $sku -Linux
# Add tags if needed: -Tag @{ owner = "rob"; env = "staging" }

# Create the web app
# Currently can't directly set the runtime when creating
New-AzWebApp -ResourceGroupName $resourceGroup -Name $appName -AppServicePlan $appServicePlan

# # Clean up temporary files
# Disconnect-AzAccount
