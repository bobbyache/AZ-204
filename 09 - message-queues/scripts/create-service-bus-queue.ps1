$myLocation = "eastus"
$myResourceGroup = "robazresourcegroup"
$myNamespaceName = "robazservicebus$([System.Guid]::NewGuid().ToString())"

Connect-AzAccount

New-AzResourceGroup -Name $myResourceGroup -Location $myLocation

New-AzServiceBusNamespace `
    -ResourceGroupName $myResourceGroup `
    -Name $myNamespaceName `
    -Location $myLocation

New-AzServiceBusQueue `
    -ResourceGroupName $myResourceGroup `
    -NamespaceName $myNamespaceName `
    -Name "az204-queue"

# Remove the comment below to delete the resource group without waiting for confirmation
# Remove-AzResourceGroup -Name $myResourceGroup -Force
