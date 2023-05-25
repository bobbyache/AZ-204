

# Overview

[Here is a page that explains a number of deployment approaches](https://learn.microsoft.com/en-us/cli/azure/webapp/deployment/source?view=azure-cli-latest) for a Web App.


# Create a static HTML web app by using Azure Cloud Shell

https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-app-service/7-create-html-web-app

# Deploy an ASP.NET Core and Azure SQL Database app to Azure App Service

The following [tutorial deploys an ASP.NET Core app to an Azure App Service and connects to an Azure SQL Database](https://learn.microsoft.com/en-us/azure/app-service/tutorial-dotnetcore-sqldb-app?pivots=platform-linux). It provisions the creation of the database and the web app and the database connection between them.

### Here is a summary of the steps

First you'll fork this repository. All edits can be done from the browser in your forked repository so do not need to clone the repository onto your local machine.

```
https://github.com/Azure-Samples/msdocs-app-service-sqldb-dotnetcore
```

Search for `web app database` and select Web App + Database resource. Create the resource and once its been created go get the default connection string name (which probably will be `AZURE_SQL_CONNECTIONSTRING`). Make a note of it.

Next thing to do is to set up a Git Actions workflow. You can do this in the Deployment Center. Sign in to your Github account and select your forked repository and save.

Now that this has been set up. Navigate to your forked GitHub repository where you will edit directly through the browser by pressing `.` and change the connection string in `appsettings.json` to point to the name of the connection string and edit the GitHub Actions workflow file so that it will generate the database schema.

The resulting `appsettings.json` file should look like this...

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "AZURE_SQL_CONNECTIONSTRING": "Server=(localdb)\\mssqllocaldb;Trusted_Connection=True;MultipleActiveResultSets=true"
  }
} 
```

Remember to update this in the `Startup.cs` too.
```csharp
            services.AddDbContext<MyDatabaseContext>(options =>
                    options.UseSqlServer(Configuration.GetConnectionString("AZURE_SQL_CONNECTIONSTRING")));
```

The main branch's workflow file should have the following edits just after the `dotnet publish` step.

```yaml
      - name: dotnet install ef
        run: dotnet tool install -g dotnet-ef

      - name: dotnet bundle migration
        run: dotnet ef migrations bundle -p DotNetCoreSqlDb/DotNetCoreSqlDb.csproj -o ${{env.DOTNET_ROOT}}/myapp/migrate
```

Finally, before running the app you'll want to make sure that the migration that you've just created has been run. Do this by going to the Development Tools -> SSH page in the Portal and run the following commands:

```bash
cd /home/site/wwwroot

# Check the directory to enure you're in the right place. All your deployment files should be here...
dir

# Now run the migration tool. This tool (set up in the GitHub Workflow) allows you to run the migration
# without requiring the .NET SDK.
./migrate
```
Note you can also run `az webapp ssh` from the Cloud Terminal to do the same thing. And you can probably do the same thing from your logged in Azure CLI on your local machine.

To stream the diagnostics logs go to App Service Logs under Monitoring and enable application logging for the file system. Next you can navigate to the Log Stream and view the action logs that take place as you add or remove items from the web app page.

To run queries against the database you'll need to add your IP address to the list of allowed IPs on the SQLServer Networking page.

[Look here for a way](https://markheath.net/post/connect-web-app-sql-database-azure-cli) to do this with a script and use [GitHub repository secrets and publish profiles](https://learn.microsoft.com/en-us/azure/app-service/deploy-github-actions?tabs=applevel).

# Build and Deploy with Visual Studio

### ASP.Net Core Web App
Creating a Web App from Visual Studio on Azure is dead easy. All you need to do is create the "ASP.NET Core Web App" by keeping all the defaults. Just make sure you configure for HTTPS. Keep the target framework as LTS.

Now when you create the project, without any changes you can select the "Build" menu and select publish. You'll go through a number of steps where you select Azure -> Azure Web Service. Once you fill out your resource group etc. you'll end up creating a new publish profile. This publish profile will be saved to your project and you'll be able to reuse it. Click "Publish" to publish the web app. It will go through the whole process of creating the web app and publishing it to the Azure Web App resource that it creates on the fly. It will end up opening the resource on the front page of the App you've just deployed.

# Quickly Build a web app

[Follow this lab](https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-app-service/7-create-html-web-app). Use `az webapp up command` to quickly make a Web App and make changes to it.



# Deployable Samples

- Can find examples to deploy [here](https://learn.microsoft.com/en-us/azure/app-service/samples-cli).

## Simple static website that can be deployed

```bash
cd .\app-service\apps\ 

git clone https://github.com/Azure-Samples/html-docs-hello-world.git

```

# Create Web App and Deploy with Azure CLI

```bash
#!/bin/bash
# parametrization
$random = Get-Random -Minimum 1000 -Maximum 9999
$resourceGroup =  "robazresourcegroup-$random"
$location = "eastus"
$appServicePlan = "robazserviceplan-$random"
$appService = "robazappservice-$random"
$appName = "mvcwebapp$random"

# create mvc app
dotnet new mvc -o .\$appName
cd .\$appName
dotnet publish -o publish
7zip a publish.zip .\publish\*

#creating resources
az group create --name $resourceGroup --location $location
az appservice plan create --name $appServicePlan --resource-group $resourceGroup --sku F1
az webapp create --name $appService --resource-group $resourceGroup --plan $appServicePlan

# deployment
az webapp deployment source config-zip --src .\publish.zip -n $appService -g $resourceGroup

```

# Enable Logging

https://learn.microsoft.com/en-us/training/modules/configure-web-app-settings/5-enable-diagnostic-logging

# Enable Auto-Scaling

https://learn.microsoft.com/en-us/training/modules/scale-apps-app-service/4-autoscale-app-service

# Web App Information Scripts

## IP Addresses

```bash
# List outbound IP addresses
az webapp show \
    --resource-group <group_name> \
    --name <app_name> \ 
    --query outboundIpAddresses \
    --output tsv

# List all possible outbound IP addresses
az webapp show \
    --resource-group <group_name> \ 
    --name <app_name> \ 
    --query possibleOutboundIpAddresses \
    --output tsv
```

## Stream logs live 

Can do this from Azure CLI.

```bash
az webapp log tail --name robazappweb --resource-group robazresourcegroup
```

## Download Log zip files (using Kudu)

- Linux - https://robazappweb.scm.azurewebsites.net/api/logs/docker/zip
- Windows - https://robazappweb.scm.azurewebsites.net/api/dump