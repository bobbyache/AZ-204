#!\bin\bash

myKeyVault=az204vault-$RANDOM
myLocation=<myLocation>

az group create --name az204-vault-rg --location $myLocation

az keyvault create --name $myKeyVault --resource-group az204-vault-rg --location $myLocation

az keyvault create --name $myKeyVault --resource-group az204-vault-rg --location $myLocation

az keyvault secret set --vault-name $myKeyVault --name "ExamplePassword" --value "hVFkk965BuUv"

az keyvault secret show --name "ExamplePassword" --vault-name $myKeyVault

az group delete --name az204-vault-rg --no-wait