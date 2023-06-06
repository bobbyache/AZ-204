

- [12 Learning Path Labs](https://microsoftlearning.github.io/AZ-204-DevelopingSolutionsforMicrosoftAzure/)

Download the repository with samples + Labs:

```
cd .\Code\azure\
git clone https://github.com/MicrosoftLearning/AZ-204-DevelopingSolutionsforMicrosoftAzure.git
```

# [Lab 01: Build a web application on Azure platform as a service offerings](https://microsoftlearning.github.io/AZ-204-DevelopingSolutionsforMicrosoftAzure/Instructions/Labs/AZ-204_lab_01.html)

Create the API

```PowerShell
cd .\Code\azure\
git clone https://github.com/MicrosoftLearning/AZ-204-DevelopingSolutionsforMicrosoftAzure.git

az login

az webapp list --resource-group ManagedPlatform --query "[?starts_with(name, 'imgapi')]. { name: name }" --output tsv
cd "\Allfiles\Labs\01\Starter\API"
az webapp deployment source config-zip --resource-group ManagedPlatform --src api.zip --name imgapirobblake
```
Create the web app
```PowerShell
az webapp list --resource-group ManagedPlatform --query "[?starts_with(name, 'imgweb')].{ Name:name}" --output tsv
az webapp deployment source config-zip --resource-group ManagedPlatform --src web.zip --name imgwebrobblake
```