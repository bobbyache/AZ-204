In App Service, app settings are variables passed as environment variables to the application code. For Linux apps and custom containers, App Service passes app settings to the container using the --env flag to set the environment variable in the container.

For ASP.NET and ASP.NET Core developers, setting app settings in App Service are like setting them in "<appSettings>" in Web.config or appsettings.json, but the values in App Service override the ones in Web.config or appsettings.json. You can keep development settings (for example, local MySQL password) in Web.config or appsettings.json and production secrets (for example, Azure MySQL database password) safely in App Service. The same code uses your development settings when you debug locally, and it uses your production secrets when deployed to Azure.

App settings are always encrypted when stored (encrypted-at-rest).

## Adding and editing settings

To add a new app setting, select New application setting. If you're using deployment slots you can specify if your setting is swappable or not. In the dialog, you can stick the setting to the current slot.

To edit a setting, select the Edit button on the right side.

When finished, select Update. Don't forget to select Save back in the Configuration page.

In a default, or custom, Linux container any nested JSON key structure in the app setting name like ApplicationInsights:InstrumentationKey needs to be configured in App Service as ApplicationInsights__InstrumentationKey for the key name. In other words, any : should be replaced by __ (double underscore).

To add or edit app settings in bulk, select the Advanced edit button. When finished, select Update.


# Configure connection strings

For ASP.NET and ASP.NET Core developers, the values you set in App Service override the ones in Web.config. For other language stacks, it's better to use app settings instead, because connection strings require special formatting in the variable keys in order to access the values. Connection strings are always encrypted when stored (encrypted-at-rest).

There is one case where you may want to use connection strings instead of app settings for non-.NET languages: certain Azure database types are backed up along with the app only if you configure a connection string for the database in your App Service app.

Adding and editing connection strings follow the same principles as other app settings and they can also be tied to deployment slots.

---

# Configure general settings

In the Configuration > General settings section you can configure some common settings for your app. Some settings require you to scale up to higher pricing tiers.

A list of the currently available settings:

 - Stack settings: The software stack to run the app, including the language and SDK versions. For Linux apps and custom container apps, you can also set an optional start-up command or file.
 - Platform settings: Lets you configure settings for the hosting platform, including:
 - Bitness: 32-bit or 64-bit.
 - WebSocket protocol: For ASP.NET SignalR or socket.io, for example.
 - Always On: Keep the app loaded even when there's no traffic. By default, Always On isn't enabled and the app is unloaded after 20 minutes without any incoming requests. It's required for continuous WebJobs or for WebJobs that are triggered using a CRON expression.
 - Managed pipeline version: The IIS pipeline mode. Set it to Classic if you have a legacy app that requires an older version of IIS.
 - HTTP version: Set to 2.0 to enable support for HTTPS/2 protocol.
 - ARR affinity: In a multi-instance deployment, ensure that the client is routed to the same instance for the life of the session. You can set this option to Off for stateless applications.
 - Debugging: Enable remote debugging for ASP.NET, ASP.NET Core, or Node.js apps. This option turns off automatically after 48 hours.
 - Incoming client certificates: require client certificates in mutual authentication. TLS mutual authentication is used to restrict access to your app by enabling different types of authentication for it.

---

# Configure path mappings

In the Configuration > Path mappings section you can configure handler mappings, and virtual application and directory mappings. The Path mappings page displays different options based on the OS type.

## Windows apps (uncontainerized)

For Windows apps, you can customize the IIS handler mappings and virtual applications and directories.

Handler mappings let you add custom script processors to handle requests for specific file extensions. To add a custom handler, select New handler. Configure the handler as follows:

- Extension: The file extension you want to handle, such as *.php or handler.fcgi.
- Script processor: The absolute path of the script processor. Requests to files that match the file extension are processed by the script processor. Use the path D:\home\site\wwwroot to refer to your app's root directory.
- Arguments: Optional command-line arguments for the script processor.

Each app has the default root path (/) mapped to D:\home\site\wwwroot, where your code is deployed by default. If your app root is in a different folder, or if your repository has more than one application, you can edit or add virtual applications and directories.

You can configure virtual applications and directories by specifying each virtual directory and its corresponding physical path relative to the website root (D:\home). To mark a virtual directory as a web application, clear the Directory check box.

## Linux and containerized apps

You can add custom storage for your containerized app. Containerized apps include all Linux apps and also the Windows and Linux custom containers running on App Service. Select New Azure Storage Mount and configure your custom storage as follows:

- Name: The display name.
- Configuration options: Basic or Advanced.
- Storage accounts: The storage account with the container you want.
- Storage type: Azure Blobs or Azure Files. Windows container apps only support Azure Files.
- Storage container: For basic configuration, the container you want.
- Share name: For advanced configuration, the file share name.
- Access key: For advanced configuration, the access key.
- Mount path: The absolute path in your container to mount the custom storage.

---


# Enable diagnostic logging

There are built-in diagnostics to assist with debugging an App Service app. In this lesson, you learn how to enable diagnostic logging and add instrumentation to your application, and how to access the information logged by Azure.

- Application logging logs messages generated by your application code. The messages are generated by the web framework you choose, or from your application code directly using the standard logging pattern of your language. Each message is assigned one of the following categories: Critical, Error, Warning, Info, Debug, and Trace.
- Web server logging logs raw HTTP request data in the W3C extended log file format. Each log message includes data like the HTTP method, resource URI, client IP, client port, user agent, response code, and so on.
- Detailed error logging logs copies of the .html error pages that would have been sent to the client browser. For security reasons, detailed error pages shouldn't be sent to clients in production, but App Service can save the error page each time an application error occurs that has HTTP code 400 or greater.
- Failed request tracing  are detailed tracing information on failed requests, including a trace of the IIS components used to process the request and the time taken in each component. One folder is generated for each failed request, which contains the XML log file, and the XSL stylesheet to view the log file with.
- Deployment logging helps determine why a deployment failed. Deployment logging happens automatically and there are no configurable settings for deployment logging.


### OS support

- Application logging and Deployment Logging is supported on Windows, Linux
- Web server logging, detailed error logging, and failed request tracing is supported on Windows

### Log file locations

- Application logging and Web server logs are located on the App Service file system and/or Azure Storage blobs
- Detailed error, deployment logging as well as request tracing logs are located on the App Service file system

# Enable application logging (Windows)

To enable application logging for Windows apps in the Azure portal, navigate to your app and select App Service logs and sSelect On for either Application Logging (Filesystem) or Application Logging (Blob), or both. The Filesystem option is for temporary debugging purposes, and turns itself off in 12 hours. The Blob option is for long-term logging, and needs a blob storage container to write logs to. If you regenerate your storage account's access keys, you must reset the respective logging configuration to use the updated access keys. To do this turn the logging feature off and then on again.

---


# Configure security certificates

You've been asked to help secure information being transmitted between your company’s app and the customer. Azure App Service has tools that let you create, upload, or import a private certificate or a public certificate into App Service.

A certificate uploaded into an app is stored in a deployment unit that is bound to the app service plan's resource group and region combination (internally called a webspace). This makes the certificate accessible to other apps in the same resource group and region combination.


## Certificate Options for App Service

- Create a free App Service managed certificate is a private certificate that's free of charge and easy to use if you just need to secure your custom domain in App Service.
- Purchase an App Service certificate is a private certificate that's managed by Azure. It combines the simplicity of automated certificate management and the flexibility of renewal and export options.
- Import a certificate from Key Vault is useful if you use Azure Key Vault to manage your certificates.
- Upload a private certificate is if you already have a private certificate from a third-party provider, you can upload it.
- Public certificates aren't used to secure custom domains, but you can load them into your code if you need them to access remote resources.

## Private certificate requirements

The free App Service managed certificate and the App Service certificate already satisfy the requirements of App Service. If you want to use a private certificate in App Service, your certificate must meet the following requirements:

- Exported as a password-protected PFX file, encrypted using triple DES.
- Contains private key at least 2048 bits long
- Contains all intermediate certificates in the certificate chain

To secure a custom domain in a TLS binding, the certificate has other requirements:

- Contains an Extended Key Usage for server authentication (OID = 1.3.6.1.5.5.7.3.1)
- Signed by a trusted certificate authority

## Creating a free managed certificate

To create custom TLS/SSL bindings or enable client certificates for your App Service app, your App Service plan must be in the Basic, Standard, Premium, or Isolated tier.

The free App Service managed certificate is a turn-key solution for securing your custom DNS name in App Service. It's a TLS/SSL server certificate that's fully managed by App Service and renewed continuously and automatically in six-month increments, 45 days before expiration. You create the certificate and bind it to a custom domain, and let App Service do the rest.

The free certificate comes with the following limitations:

- Doesn't support wildcard certificates.
- Doesn't support usage as a client certificate by using certificate thumbprint, which is planned for deprecation and removal.
- Doesn't support private DNS.
- Isn't exportable.
- Isn't supported in an App Service Environment (ASE).
- Only supports alphanumeric characters, dashes (-), and periods (.).

# Import an App Service Certificate

If you purchase an App Service Certificate from Azure, Azure manages the following tasks:

- Takes care of the purchase process from certificate provider.
- Performs domain verification of the certificate.
- Maintains the certificate in Azure Key Vault.
- Manages certificate renewal.
- Synchronize the certificate automatically with the imported copies in App Service apps.

If you already have a working App Service certificate, you can:

- Import the certificate into App Service.
- Manage the certificate, such as renew, rekey, and export it.