Connect-AzAccount

# Create resource group and required standard SKU storage account
New-AzResourceGroup -Name robazresourcegroup -Location eastus

# Get a list of locations
(Get-AzLocation).Location

# New-AzVm -ResourceGroupName robazresourcegroup -Name vm1 -Location eastus -PublicIPAddressName 'MyPublicIP' -OpenPort 80,443,3389

# Create a VM with a public IP
New-AzVM `
	-ResourceGroupName robazresourcegroup `
	-Location eastus `
	-Name vm1 `
	-Credential (New-Object System.Management.Automation.PSCredential ('rob123', (ConvertTo-SecureString "9eERhs%zkhL7G4" -AsPlainText -Force))) `
	-PublicIPAddressName 'MyPublicIP' `
	-Size Standard_B2s `
	-OpenPort 22,80,443,3389

# Get some information from the newly created VM
(Get-AzVM -Name vm1 -ResourceGroupName robazresourcegroup).HardwareProfile
(Get-AzVM -Name vm1 -ResourceGroupName robazresourcegroup).OsProfile

# Get the Public IP address
(Get-AzPublicIpAddress -Name MyPublicIp -ResourceGroupName robazresourcegroup).IpAddress
# Get the Private IP Address
(Get-AzNetworkInterface -Name ((Get-AzVM -Name vm1 -ResourceGroupName robazresourcegroup).NetworkProfile.NetworkInterfaces.Id.Split('/') | Select -Last 1)).IpConfigurations.PrivateIpAddress

# At this point you can use Remote Desktop Connection to communicate with your VM.

# Finally you an set some tags
Update-AzTag `
	-ResourceId /subscriptions/926c5cae-cfdc-46f8-b94e-c2a9c416d9fe/resourceGroups/robazresourcegroup/providers/Microsoft.Compute/virtualMachines/vm1 `
	-Tag @{"owner"="rob"; "costcenter"="accounts"} `
	-Operation Merge

(Get-AzVM -Name vm1 -ResourceGroupName robazresourcegroup).Tags

