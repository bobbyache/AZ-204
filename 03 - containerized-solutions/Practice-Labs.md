# Build a container registry

- [Build and run a container registry](https://learn.microsoft.com/en-us/training/modules/publish-container-image-to-azure-container-registry/6-build-run-image-azure-container-registry)


```bash
az group create --name robazresourcegroup1 --location eastus
az acr create --resource-group robazresourcegroup1 --name robazcontainerregistry1 --sku Basic

cd /c/code/azure
mkdir container-docker-file
cd container-docker-file/

echo FROM mcr.microsoft.com/hello-world > Dockerfile
cat Dockerfile

az acr build --image sample/hello-world:v1 --registry robazcontainerregistry1 --file Dockerfile .

az acr repository list --name robazcontainerregistry1 --output table

az acr repository show-tags --name robazcontainerregistry1 --repository sample/hello-world --output table

az acr run --registry robazcontainerregistry1 --cmd '$Registry/sample/hello-world:v1' /dev/null
```

# Deploy a container instance

- [Deploy a container instance by using the Azure CLI](https://learn.microsoft.com/en-us/training/modules/create-run-container-images-azure-container-instances/3-run-azure-container-instances-cloud-shell)

```bash
az group create --name robazresourcegroup --location eastus
DNS_NAME_LABEL=robazcoolwebapp

az container create --resource-group robazresourcegroup --name $DNS_NAME_LABEL --image mcr.microsoft.com/azuredocs/aci-helloworld --ports 80 --dns-name-label $DNS_NAME_LABEL --location eastus

az container show --resource-group robazresourcegroup --name $DNS_NAME_LABEL --query "{FQDN:ipAddress.fqdn, ProvisioningState:provisioningState}" --out table

curl robazcoolwebapp.eastus.azurecontainer.io

az group delete --name robazresourcegroup --no-wait
```

# Environment Variables and Restart Values

Also see scripts folder...

- [Run containerized tasks with restart policies](https://learn.microsoft.com/en-us/training/modules/create-run-container-images-azure-container-instances/4-run-containerized-tasks-restart-policies)
- [Set environment variables in container instances](https://learn.microsoft.com/en-us/training/modules/create-run-container-images-azure-container-instances/5-set-environment-variables-azure-container-instances)

```bash
#!/bin/bash

az group create --name robazresourcegroup --location eastus

az container create \
    --resource-group robazresourcegroup \
    --file env.yaml \

az container show --resource-group robazresourcegroup \
    --name $DNS_NAME_LABEL \
    --query "{FQDN:ipAddress.fqdn, ProvisioningState:provisioningState}" \
    --out table

curl robazcoolwebapp.eastus.azurecontainer.io

# az group delete --name robazresourcegroup --no-wait
```

- [Mounting file shares](https://learn.microsoft.com/en-us/training/modules/create-run-container-images-azure-container-instances/6-mount-azure-file-share-azure-container-instances)
- [Deploy a container app](https://learn.microsoft.com/en-us/training/modules/implement-azure-container-apps/3-exercise-deploy-app)


# Container Group

```
az container create --resource-group demo --file deployment.yml
```

# Build and Deploy a Container Instance and Container App Environment (Lab 5)

- [What is the difference between Container Apps and Container Instances?](https://www.youtube.com/watch?v=YU-MKS0rmTE)

```PowerShell
dotnet new console --output . --name ipcheck --framework net6.0

Get-Content ipcheck.csproj

New-Item Dockerfile
Get-Content Dockerfile

code .

dotnet run
```


```bash
#!/bin/bash

registryName=conregistry$RANDOM

# By redirecting the output of the check-name command to /dev/null, 
# any output produced by the command will be discarded and not displayed in the terminal.
if az acr check-name --name "$registryName" > /dev/null; then

    # Create and show
    az acr create --resource-group ContainerCompute --name $registryName --sku Basic
    # az acr list
    # az acr list --query "max_by([], &creationDate).name" --output tsv

    acrName=$(az acr list --query "max_by([], &creationDate).name" --output tsv)

    echo $acrName

    az acr build --registry $acrName --image ipcheck:latest .


else
    echo "The registry name is NOT available"
fi
```

### Create App Container Environment

```bash
az extension add --name containerapp --upgrade

# Note: Azure Container Apps resources have migrated from the Microsoft.Web namespace to the Microsoft.App namespace.
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights

# An environment in Azure Container Apps creates a secure boundary around a group of container apps. Container Apps 
# deployed to the same environment are deployed in the same virtual network and write logs to the 
# same Log Analytics workspace.
myRG=ContainerCompute
myAppConEnv=az204-env-$RANDOM

az containerapp env create --name $myAppConEnv --resource-group $myRG --location eastus

# By setting --ingress to external, you make the container app available to public requests. The command returns a link to access your app.
az containerapp create \
    --name my-container-app \
    --resource-group $myRG \
    --environment $myAppConEnv \
    --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
    --target-port 80 \
    --ingress 'external' \
    --query properties.configuration.ingress.fqdn

# Fetch the result from the terminal and curl it
# curl "result"
```

# Very Simple Docker File

`Dockerfile`
```
FROM mcr.microsoft.com/hello-world

```