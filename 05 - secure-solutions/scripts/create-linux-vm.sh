#!\bin\bash

### NOTE: This script is meant to be run one line at a time...

az login

# Create resource group
az group create \
    --name robazresourcegroup \
    --location eastus

# List images and decide which one to use
# az vm image list

# Create the vm
az vm create --name vm1 \
    --image UbuntuLTS \
    --authentication-type password \
    --admin-username rob123 \
    --admin-password 9eERhs%zkhL7G4 \
    --resource-group robazresourcegroup

# az vm show -g robazresourcegroup -n vm1 --query "{ sku:storageProfile.imageReference.sku}"

# Get the public IP Address
# az vm list-ip-addresses --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress"

# SSH into it to ensure that you can get into your virtual machine... (change ip address to VMs ip address)
ssh rob123@74.235.74.19

# Test your virtual machine
hostnamectl
logout

# Update the tags on the virtual machine
az vm update -n vm1 -g robazresourcegroup --set tags.department=accounting tags.owner=cygsoft
az vm show -g robazresourcegroup -n vm1 --query "{ tags: tags}"

# Stop and deallocate
az vm stop -g robazresourcegroup -n vm1
az vm deallocate -g robazresourcegroup -n vm1
az vm delete -n vm1 -g robazresourcegroup

az group delete --name robazresourcegroup