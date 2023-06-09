# Connect-AzAccount

# # Get details for the current subscription
# Get-AzContext
# Set-AzContext -SubscriptionId "a340a8e0-18f2-4355-bf29-beaad05b582e" # try and switch account

New-AzResourceGroup -Name "robazresourcegroup" -Location "eastus"

New-AzVM -ResourceGroupName "robazresourcegroup" -Location "eastus" -VMName "myVM" -Image "win2016datacenter" -Credential (Get-Credential -UserName "azureuser" -Password "myPassword12")

# # Assign Managed Identity and Contributor role to the VM's scope
# $vm = Get-AzVM -ResourceGroupName "robazresourcegroup" -Name "myVM"
# $identity = New-AzUserAssignedIdentity -ResourceGroupName "robazresourcegroup" -Name "myUserAssignedIdentity"
# $vm = Set-AzVM -VM $vm -AssignIdentity $identity.Id -RoleDefinitionName "Contributor" -Scope "/subscriptions/ca5d6b8a-b966-4534-882c-65db19cd968d/resourceGroups/testrobazresourcegroup"
# Update-AzVM -VM $vm

# Assign User-Assigned Identity to the VM
$identity = New-AzUserAssignedIdentity -ResourceGroupName "robazresourcegroup" -Name "myUserAssignedIdentity"
Set-AzVMExtension -ResourceGroupName "robazresourcegroup" -VMName "myVM" -Name "UserAssignedIdentityExtension" -Publisher "Microsoft.ManagedIdentity" -Type "ManagedIdentityExtensionForLinux" -TypeHandlerVersion "1.0" -SettingString ('{{"identityId":"{0}"}}' -f $identity.Id) -Location "eastus"

Get-AzVM -ResourceGroupName "robazresourcegroup" -Name "myVM" | Select-Object -ExpandProperty "Id" | Get-AzVM

# Remove-AzResourceGroup -Name "robazresourcegroup"

# New-AzVM -ResourceGroupName "robazresourcegroup" -Name "myVM2" -Image "UbuntuLTS" -AdminUsername "azureuser" -AdminPassword "myPassword12" -AssignIdentity $identity.Id -Role "<ROLE>" -Scope "<SUBSCRIPTION>"
