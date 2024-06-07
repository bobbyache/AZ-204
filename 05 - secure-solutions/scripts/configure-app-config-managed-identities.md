# Configure Managed Identity for Azure App Config

### Add a system-assigned identity

- Since there can only be one system-assigned managed identity:
    - Assign to an existing Azure App Service
    - `az appconfig identity` and then `assign`

```powershell
az appconfig identity assign `
    --name $testAppConfigService `
    --resource-group $resourceGroup
```

### Add a user-assigned identity
- create the identity and then assign its resource identifier to your store. 

```PowerShell
az identity create `
    --name $userAssignedIdentity `
    --resource-group $resourceGroup
```

```PowerShell
$identity1 = "/subscriptions/$subscriptionId/resourcegroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUserAssignedIdentity_1"
$identity2 = "/subscriptions/$subscriptionId/resourcegroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUserAssignedIdentity_2"

# Can configure multiple identities seperated by spaces...
az appconfig identity assign --name myTestAppConfigStore `
    --resource-group myResourceGroup `
    --identities $identity1 $identity2
```
# References

- [Configure managed identities for Azure resources on an Azure VM using Azure CLI](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/qs-configure-cli-windows-vm)