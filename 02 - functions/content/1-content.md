Azure Functions lets you develop serverless applications on Microsoft Azure. You can write just the code you need for the problem at hand, without worrying about a whole application or the infrastructure to run it.

# Discover Azure Functions

Azure Functions is a serverless solution that allows you to write less code, maintain less infrastructure, and save on costs. Instead of worrying about deploying and maintaining servers, the cloud infrastructure provides all the up-to-date resources needed to keep your applications running.

We often build systems to react to a series of critical events. Whether you're building a web API, responding to database changes, processing IoT data streams, or even managing message queues - every application needs a way to run some code as these events occur.

Azure Functions supports triggers, which are ways to start execution of your code, and bindings, which are ways to simplify coding for input and output data. There are other integration and automation services in Azure and they all can solve integration problems and automate business processes. They can all define input, actions, conditions, and output.

Compare Azure Functions and Azure Logic Apps
Both Functions and Logic Apps are Azure Services that enable serverless workloads. Azure Functions is a serverless compute service, whereas Azure Logic Apps is a serverless workflow integration platform. Both can create complex orchestrations. An orchestration is a collection of functions or steps, called actions in Logic Apps, that are executed to accomplish a complex task.

For Azure Functions, you develop orchestrations by writing code and using the Durable Functions extension. For Logic Apps, you create orchestrations by using a GUI or editing configuration files.

# Azure Functions vs. Logic Apps

Azure Functions use a code-first (imperative) approach whereas Logic App use a designer-first (declarative) approach.
Azure Functions have about a dozen built-in code-written binding types whereas Logic Apps have a large collection of connectors.
Azure Functions implement activities as code functions whereas Logic Apps provide a large collection of ready-made actions.
Azure Functions are monitored using Azure Application Insights whereas Logic Apps are monitored from the Azure Portal of via Azure Monitor Logs.
Azure Functions can run in Azure, or locally. Logic Apps have the same capability and can also run on premises.

Like Azure Functions, Azure App Service WebJobs with the WebJobs SDK is a code-first integration service that is designed for developers. Both are built on Azure App Service and support features such as source control integration, authentication, and monitoring with Application Insights integration.

Azure Functions is built on the WebJobs SDK, so it shares many of the same event triggers and connections to other Azure services. 

- Functions are a serverless app model with automatic scaling.
- WebJobs are not serverless and cannot automatically scale.
- Functions can be developed and tested in the browser.
- WebJobs cannot be developed and tested in the browser.
- Functions have pay-per-use pricing.
- WebJobs do not support pay-per-use pricing.
- Functions can integrate with WebJobs.
- Functions support more trigger events that WebJobs do.

Azure Functions offers more developer productivity than Azure App Service WebJobs does. It also offers more options for programming languages, development environments, Azure service integration, and pricing. For most scenarios, it's the best choice.

---

# Compare Azure Functions hosting options

When you create a function app in Azure, you must choose a hosting plan for your app. There are three basic hosting plans available for Azure Functions: Consumption plan, Premium plan, and Dedicated (App service) Dedicated plan. All hosting plans are generally available (GA) on both Linux and Windows virtual machines.

The hosting plan you choose dictates the following behaviors:

- How your function app is scaled.
- The resources available to each function app instance.
- Support for advanced functionality, such as Azure Virtual Network connectivity.


The Consumption plan is the default hosting plan. It scales automatically and you only pay for compute resources when your functions are running. Instances of the Functions host are dynamically added and removed based on the number of incoming events.

The Premium plan automatically scales based on demand using pre-warmed workers, which run applications with no delay after being idle, runs on more powerful instances, and connects to virtual networks.

The dedicated plan rusns your functions within an App Service plan at regular App Service plan rates. Best for long-running scenarios where Durable Functions can't be used.

There are two other hosting options, which provide the highest amount of control and isolation in which to run your function apps: ASE and Kubernetes.

App Service Environment (ASE) is an App Service feature that provides a fully isolated and dedicated environment for securely running App Service apps at high scale.

Kubernetes provides a fully isolated and dedicated environment running on top of the Kubernetes platform.

# Hosting plans and scaling

The Consumption plan and Premium plan are both event driven and scales out automatically, even during periods of high load. Azure Functions infrastructure scales CPU and memory resources by adding more instances of the Functions host, based on the number of incoming trigger events.

The Consumption plan scales out to a maximum of 200 instances on Windows and 100 instances on Linux.
The Premium plan scales out to a maximum of 100 instances on Windows and between 20-100 instances on Linux.

Dedicated plans support both manual and autoscaling to a maximum of between 10 - 20 instances.
ASE plans support both manual and autoscaling to a maximum of 100 instances.

Kubernetes are event-driven and autoscale for Kurbernetes clusters using KEDA. Kubernetes autoscale instance ceiling limit varies by cluster.

The maximum scale out for all plans may also vary by region and hosting plan.

The functionTimeout property in the host.json project file specifies the timeout duration for functions in a function app. This property applies specifically to function executions. After the trigger starts function execution, the function needs to return/respond within the timeout duration.

# Function app timeout duration

The functionTimeout property in the host.json project file specifies the timeout duration for functions in a function app. This property applies specifically to function executions. After the trigger starts function execution, the function needs to return/respond within the timeout duration.

The default timeout for the Consumption plan is 5 minutes and can be adjusted to a maximum of 10 minutes.
The default timeout for the Premium plan is 302 minutes and can be adjusted to a maximum of Unlimited minutes.
The default timeout for the Dedicated plan is 302 minutes and can be adjusted to a maximum of Unlimited minutes.


# Storage account requirements

On any plan, a function app requires a general Azure Storage account, which supports Azure Blob, Queue, Files, and Table storage. This is because Functions rely on Azure Storage for operations such as managing triggers and logging function executions, but some storage accounts don't support queues and tables.

The same storage account used by your function app can also be used by your triggers and bindings to store your application data. However, for storage-intensive operations, you should use a separate storage account.

---

# Scale Azure Functions

In the Consumption and Premium plans, Azure Functions scales CPU and memory resources by adding more instances of the Functions host. The number of instances is determined on the number of events that trigger a function.

Each instance of the Functions host in the Consumption plan is limited to 1.5 GB of memory and one CPU. An instance of the host is the entire function app, meaning all functions within a function app share resource within an instance and scale at the same time. Function apps that share the same Consumption plan scale independently. In the Premium plan, the plan size determines the available memory and CPU for all apps in that plan on that instance.

Function code files are stored on Azure Files shares on the function's main storage account. When you delete the main storage account of the function app, the function code files are deleted and can't be recovered.

Runtime scaling
Azure Functions uses a component called the scale controller to monitor the rate of events and determine whether to scale out or scale in. The scale controller uses heuristics for each trigger type. For example, when you're using an Azure Queue storage trigger, it scales based on the queue length and the age of the oldest queue message.

The unit of scale for Azure Functions is the function app. When the function app is scaled out, more resources are allocated to run multiple instances of the Azure Functions host. Conversely, as compute demand is reduced, the scale controller removes function host instances. The number of instances is eventually "scaled in" to zero when no functions are running within a function app.

After your function app has been idle for a number of minutes, the platform may scale the number of instances on which your app runs in to zero. The next request has the added latency of scaling from zero to one. This latency is referred to as a cold start.

## Scaling behaviors

Scaling can vary on many factors, and scale differently based on the trigger and language selected. There are a few intricacies of scaling behaviors to be aware of:

- Maximum instances: A single function app only scales out to a maximum of 200 instances. A single instance may process more than one message or request at a time though, so there isn't a set limit on number of concurrent executions.

- New instance rate: For HTTP triggers, new instances are allocated, at most, once per second. For non-HTTP triggers, new instances are allocated, at most, once every 30 seconds.

# Limit scale-out

You may wish to restrict the maximum number of instances an app used to scale out. This is most common for cases where a downstream component like a database has limited throughput. By default, Consumption plan functions scale out to as many as 200 instances, and Premium plan functions scales out to as many as 100 instances. You can specify a lower maximum for a specific app by modifying the functionAppScaleLimit value. The functionAppScaleLimit can be set to 0 or null for unrestricted, or a valid value between 1 and the app maximum.

---

Explore Azure Functions development

A function contains two important pieces - your code, which can be written in various languages, and some config, the function.json file. For compiled languages, this config file is generated automatically from annotations in your code. For scripting languages, you must provide the config file yourself.

The function.json file defines the function's trigger, bindings, and other configuration settings. Every function has one and only one trigger. The runtime uses this config file to determine the events to monitor and how to pass data into and return data from a function execution. Following is an example function.json file.

The bindings property is where you configure both triggers and bindings. Each binding shares a few common settings and some settings that are specific to a particular type of binding. Every binding requires the following settings:

The string property "type" is the name of the binding. For example, queueTrigger.
The string property "direction" indicates whether the binding is for receiving data into the function or sending data from the function. For example, in or out.
The string property "name" is the name that is used for the bound data in the function. For example, myQueue.

# Function app

A function app provides an execution context in Azure in which your functions run. As such, it's the unit of deployment and management for your functions. A function app is composed of one or more individual functions that are managed, deployed, and scaled together. All of the functions in a function app share the same pricing plan, deployment method, and runtime version. Think of a function app as a way to organize and collectively manage your functions.

In Functions 2.x all functions in a function app must be authored in the same language. In previous versions of the Azure Functions runtime, this wasn't required.

## Folder structure

The code for all the functions in a specific function app is located in a root project folder that contains a host configuration file. The host.json file contains runtime-specific configurations and is in the root folder of the function app. A bin folder contains packages and other library files that the function app requires. Specific folder structures required by the function app depend on language.


## Local development environments

Functions make it easy to use your favorite code editor and development tools to create and test functions on your local computer. Your local functions can connect to live Azure services, and you can debug them on your local computer using the full Functions runtime.

The way in which you develop functions on your local computer depends on your language and tooling preferences.

Do not mix local development with portal development in the same function app. When you create and publish functions from a local project, you should not try to maintain or modify project code in the portal.

---

# Create triggers and bindings

Triggers cause a function to run. A trigger defines how a function is invoked and a function must have exactly one trigger. Triggers have associated data, which is often provided as the payload of the function.

Binding to a function is a way of declaratively connecting another resource to the function; bindings may be connected as input bindings, output bindings, or both. Data from bindings is provided to the function as parameters.

You can mix and match different bindings to suit your needs. Bindings are optional and a function might have one or multiple input and/or output bindings.

Triggers and bindings let you avoid hardcoding access to other services. Your function receives data (for example, the content of a queue message) in function parameters. You send data (for example, to create a queue message) by using the return value of the function.

## Trigger and binding definitions

Triggers and bindings are defined differently depending on the development language.

In the C# class library triggers and bindings are configured by decorating methods and parameters with C# attributes.
In Java triggers and bindings are configured by decorating methods and parameters with Java annotations.
In JavaScript/PowerShell/Python/TypeScript triggers and bindings are configured by updating function.json schema.

For languages that rely on function.json, the portal provides a UI for adding bindings in the Integration tab. You can also edit the file directly in the portal in the Code + test tab of your function.

In .NET and Java, the parameter type defines the data type for input data. For instance, use string to bind to the text of a queue trigger, a byte array to read as binary, and a custom type to de-serialize to an object. Since .NET class library functions and Java functions don't rely on function.json for binding definitions, they can't be created and edited in the portal. C# portal editing is based on C# script, which uses function.json instead of attributes.

For languages that are dynamically typed such as JavaScript, use the dataType property in the function.json file. For example, to read the content of an HTTP request in binary format, set dataType to binary. the other dataType options are stream and string.

## Binding direction

All triggers and bindings have a direction property in the function.json file:

- For triggers, the direction is always in
- Input and output bindings use in and out
- Some bindings support a special direction inout. If you use inout, only the Advanced editor is available via the Integrate tab in the portal.
When you use attributes in a class library to configure triggers and bindings, the direction is provided in an attribute constructor or inferred from the parameter type.

---

# Connect functions to Azure services

Your function project references connection information by name from its configuration provider. It doesn't directly accept the connection details, allowing them to be changed across environments. For example, a trigger definition might include a connection property, but you can't set the connection string directly in a function.json. Instead, you would set connection to the name of an environment variable that contains the connection string.

The default configuration provider uses environment variables that are set in Application Settings when running in the Azure Functions service, or from the local settings file when developing locally.

## Configure an identity-based connection

Some connections in Azure Functions are configured to use an identity instead of a secret. Support depends on the extension using the connection. In some cases, a connection string may still be required in Functions even though the service to which you're connecting supports identity-based connections.

Identity-based connections are not supported with Durable Functions.

When hosted in the Azure Functions service, identity-based connections use a managed identity. The system-assigned identity is used by default, although a user-assigned identity can be specified with the credential and clientID properties. When run in other contexts, such as local development, your developer identity is used instead.

## Grant permission to the identity

Whatever identity is being used must have permissions to perform the intended actions. This is typically done by assigning a role in Azure RBAC or specifying the identity in an access policy, depending on the service to which you're connecting.

Some permissions might be exposed by the target service that are not necessary for all contexts. Where possible, adhere to the principle of least privilege, granting the identity only required privileges.