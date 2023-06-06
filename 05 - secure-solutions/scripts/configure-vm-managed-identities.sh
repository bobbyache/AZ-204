#! /bin/bash

# az login

# # Get details for the current subscription
# az account list -o table # or
# az account show #note the "id" is the subscription id
# az account set --subscription a340a8e0-18f2-4355-bf29-beaad05b582e # try and switch account


az group create --name robazresourcegroup --location eastus


az vm create --resource-group robazresourcegroup --location eastus --name myVM --image win2016datacenter --generate-ssh-keys --admin-username azureuser --admin-password myPassword12 \
    # --assign-identity --role Contributor --scope "/subscriptions/ca5d6b8a-b966-4534-882c-65db19cd968d/resourceGroups/testrobazresourcegroup"  <-- couldn't get this to work...
az vm identity assign -g robazresourcegroup -n myVM

az identity create -g robazresourcegroup -n myUserAssignedIdentity
az vm identity assign -g robazresourcegroup -n myVM --identities myUserAssignedIdentity


az vm list --show-details --output table

# az group delete --name robazresourcegroup
