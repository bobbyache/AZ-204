
## NOTE: This script is meant to be run one line at a time...

Connect-AzAccount

# Create resource group and required standard SKU storage account
New-AzResourceGroup -Name robazresourcegroup -Location eastus

# Get a list of locations
(Get-AzLocation).Location

# Create a VM with a public IP (open port 22 to for ssh)
New-AzVM `
	-ResourceGroupName robazresourcegroup `
	-Location eastus `
	-Name vm2 `
	-Image UbuntuLTS `
	-Credential (New-Object System.Management.Automation.PSCredential ('rob123', (ConvertTo-SecureString "9eERhs%zkhL7G4" -AsPlainText -Force))) `
	-PublicIPAddressName 'MyPublicIP' `
	-Size Standard_D2s_v3 `
	-OpenPort 22

# az vm create --name vm1 --image UbuntuLTS --authentication-type password 
# --admin-username rob123 --admin-password 9eERhs%zkhL7G4 --resource-group robazresourcegroup


# Get some information from the newly created VM
(Get-AzVM -Name vm1 -ResourceGroupName robazresourcegroup).HardwareProfile
(Get-AzVM -Name vm1 -ResourceGroupName robazresourcegroup).OsProfile

# Get the Public IP address
(Get-AzPublicIpAddress -Name MyPublicIp -ResourceGroupName robazresourcegroup).IpAddress
# Get the Private IP Address
(Get-AzNetworkInterface -Name ((Get-AzVM -Name vm1 -ResourceGroupName robazresourcegroup).NetworkProfile.NetworkInterfaces.Id.Split('/') | Select -Last 1)).IpConfigurations.PrivateIpAddress

# SSH into it to ensure that you can get into your virtual machine... (change ip address to VMs ip address)
# type "hostnamectl" to see the OS info and the "logout" to log out.
ssh rob123@74.235.74.19

# Finally you an set some tags
Update-AzTag `
	-ResourceId /subscriptions/926c5cae-cfdc-46f8-b94e-c2a9c416d9fe/resourceGroups/robazresourcegroup/providers/Microsoft.Compute/virtualMachines/vm1 `
	-Tag @{"owner"="rob"; "costcenter"="accounts"} `
	-Operation Merge

(Get-AzVM -Name vm1 -ResourceGroupName robazresourcegroup).Tags

