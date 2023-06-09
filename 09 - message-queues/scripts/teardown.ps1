# Set the name of the resource group you want to delete
$resourceGroup = "robazresourcegroup"

Get-AzResourceGroup | Format-Table

# Check if the resource group exists
if ($null -ne (Get-AzResourceGroup -Name $resourceGroup -ErrorAction SilentlyContinue)) {
    # If the resource group exists, delete it
    Write-Host "Deleting resource group $resourceGroup ..."
    Remove-AzResourceGroup -Name $resourceGroup -Force
    Write-Host "Resource group $resourceGroup deleted."
}
else {
    # If the resource group doesn't exist, display a message
    Write-Host "Resource group $resourceGroup does not exist."
}
