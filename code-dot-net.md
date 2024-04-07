# Cosmos DB

- [Source Content](https://learn.microsoft.com/en-us/training/modules/work-with-cosmos-db/2-cosmos-db-dotnet-overview)

```csharp
using Microsoft.Azure.Cosmos;
```
Creates a new CosmosClient with a connection string. CosmosClient is thread-safe. It's recommended to maintain a single instance of CosmosClient per lifetime of the application that enables efficient connection management and performance.
```csharp
CosmosClient client = new CosmosClient(accountEndpoint, authKey);
DatabaseResponse databaseResponse = await client.CreateDatabaseIfNotExistsAsync(databaseName, throughput);
```

```csharp
Database database = client.GetDatabase(databaseName);
DatabaseResponse databaseResponse = await database.ReadAsync();
```
Note the addition of the Partition Id.

```csharp
ContainerResponse containerResponse = 
  await databaseResponse.Database.CreateContainerIfNotExistsAsync(containerName, "/id");

Container container = database.GetContainer(containerName);
ContainerProperties containerProperties = await container.ReadContainerAsync();
```
Use the Container.CreateItemAsync method to create an item. The method requires a JSON serializable object that must contain an id property, and a partitionKey.
```csharp
ItemResponse<ToDoActivity> createdResponse = 
  await container.CreateItemAsync(newActivity, new PartitionKey(newActivity.Id));
```
Use the Container.ReadItemAsync method to read an item. The method requires type to serialize the item to along with an id property, and a partitionKey.
```csharp
ItemResponse<ToDoActivity> existingResponse = await container.ReadItemAsync<ToDoActivity>(id, new PartitionKey(newActivity.Id));
```

```csharp
await container.UpsertItemAsync(existingActivity, new PartitionKey(existingResponse.Resource.Id));
```

```csharp
await container.CreateItemAsync(
  new ToDoActivity { Id = "2", Name = "Learn guitar", Description = "Learn the C chord" }, new PartitionKey("2")
);
```

```csharp
  using FeedIterator<ToDoActivity> feedIterator = container.GetItemQueryIterator<ToDoActivity>
  (
      query,
      null,
      requestOptions: new QueryRequestOptions()
      {
          PartitionKey = new PartitionKey("3")
          ,
          MaxItemCount = 1
      }
  );

  while (feedIterator.HasMoreResults)
  {
      FeedResponse<ToDoActivity> activities = await feedIterator.ReadNextAsync();
      foreach (ToDoActivity activity in activities)
      {
          Console.WriteLine(activity.Description);
      }
  }
```

```csharp
try
{
  ...
}
catch (CosmosException ce) when (ce.StatusCode == System.Net.HttpStatusCode.Forbidden)
{
    Console.WriteLine(ce.Message);
}
```

# Blob Storage

The following packages contain the classes used to work with Blob Storage data resources:

- `Azure.Storage.Blobs`: Contains the primary classes (client objects) that you can use to operate on the service, containers, and blobs.
- `Azure.Storage.Blobs.Specialized`: Contains classes that you can use to perform operations specific to a blob type, such as block blobs.
- `Azure.Storage.Blobs.Models`: All other utility classes, structures, and enumeration types.

- **BlobServiceClient**	- Represents the storage account, and provides operations to retrieve and configure account properties, and to work with blob containers in the storage account.
- **BlobContainerClient**	- Represents a specific blob container, and provides operations to work with the container and the blobs within.
- **BlobClient**	- Represents a specific blob, and provides general operations to work with the blob, including operations to upload, download, delete, and create snapshots.
- **AppendBlobClient**	- Represents an append blob, and provides operations specific to append blobs, such as appending log data.
- **BlockBlobClient**	- Represents a block blob, and provides operations specific to block blobs, such as staging and then committing blocks of data.

```csharp
using Azure;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
```
The following example shows how to create a BlobServiceClient object and how to create a container client from a BlobServiceClient object to interact with a specific container resource:
```csharp
BlobServiceClient blobServiceClient = new BlobServiceClient(storageConnectionString);
BlobContainerClient containerClient = await blobServiceClient.CreateBlobContainerAsync(containerName);
```
The following example shows how to create a blob client to interact with a specific blob resource:
```csharp
BlobClient blobClient = containerClient.GetBlobClient(fileName);
await blobClient.UploadAsync(uploadFileStream);
```

```csharp
await foreach (BlobItem blobItem in containerClient.GetBlobsAsync())
{
  ...
}
```

```csharp
await blobClient.DownloadToAsync(Path.Combine(localPath, blobItem.Name));
```

```csharp
await containerClient.DeleteAsync();
```
### Properties
```csharp
var properties = await containerClient.GetPropertiesAsync();
```
The following code example sets metadata on a container.
```csharp
IDictionary<string, string> metadata = new Dictionary<string, string>();
metadata.Add("category", "guidance");

await containerClient.SetMetadataAsync(metadata);
```
The following code example retrieves metadata from a container.
```csharp
foreach (var metadataItem in properties.Value.Metadata)
{
    Console.WriteLine($"\tKey: {metadataItem.Key}");
    Console.WriteLine($"\tValue: {metadataItem.Value}");
}
```

### Life-cycle Policies

- [Content Source](https://learn.microsoft.com/en-us/training/modules/manage-azure-blob-storage-lifecycle/3-blob-storage-lifecycle-policies)

A lifecycle management policy is a collection of rules in a JSON document. Each rule definition within a policy includes a filter set and an action set. The filter set limits rule actions to a certain set of objects within a container or objects names. The action set applies the tier or delete actions to the filtered set of objects:

```json
{
  "rules": [
    {
      "enabled": true,
      "name": "move-to-cool",
      "type": "Lifecycle",
      "definition": {
        "actions": {
          "baseBlob": {
            "tierToCool": {
              "daysAfterModificationGreaterThan": 30
            }
          }
        },
        "filters": {
          "blobTypes": [
            "blockBlob"
          ],
          "prefixMatch": [
            "sample-container/log"
          ]
        }
      }
    }
  ]
}
```
## Set and retrieve properties and metadata for blob resources using REST
- [Source Content](https://learn.microsoft.com/en-us/training/modules/work-azure-blob-storage/6-set-retrieve-properties-metadata-rest)
Metadata headers are name/value pairs. The format for the header is:
```
x-ms-meta-name:string-value
```
### Retrieving properties and metadata

The URI syntax for getting and setting metadata headers on a blob is as follows:

```
GET/HEAD https://myaccount.blob.core.windows.net/mycontainer?restype=container
GET/HEAD https://myaccount.blob.core.windows.net/mycontainer/myblob?comp=metadata
```

```
PUT https://myaccount.blob.core.windows.net/mycontainer?comp=metadata&restype=container
PUT https://myaccount.blob.core.windows.net/mycontainer/myblob?comp=metadata
```

# Queue Storage

You'll install the following packages:
```
Azure.Core
Azure.Storage.Common
Azure.Storage.Queues
```
## Create a queue and insert a message
```csharp
QueueClient queueClient = new QueueClient(connectionString, queueName);
queueClient.CreateIfNotExists();

if (queueClient.Exists())
{
    queueClient.SendMessage(message);
}
```
## Peek
The queue client is exactly the same `QueueClient` as before. Pass `maxMessages` into method if you want to peek at more than one message.
```csharp
PeekedMessage[] peekedMessage = queueClient.PeekMessages();
```

## Change the contents
```csharp
QueueMessage[] messages = queueClient.ReceiveMessages();

queueClient.UpdateMessage(
  messages[0].MessageId, 
  messages[0].PopReceipt, 
  "Updated contents",
  TimeSpan.FromSeconds(60.0)  // Make it invisible for another 60 seconds
);
```

## Dequeue

```csharp
QueueMessage[] messages = queueClient.ReceiveMessages();

queueClient.DeleteMessage(messages[0].MessageId, messages[0].PopReceipt)
```
## Approximate message count
```csharp
int cachedMessagesCount = properties.ApproximateMessagesCount;
```
Finally you can also delete the queue: `queueClient.Delete();`.

**Note:** `Microsoft.Azure.Storage.Queue v11.2.3` has an older SDK structure a few differences to the v12 SDK. For instance:

```csharp
CloudStorageAccount account = CloudStorageAccount.Parse(connectionString);
CloudQueueClient client = account.CreateQueueClient();
CloudQueue queue = client.GetQueueReference("orders");
var messages = message.GetMessage(20, TimeSpan.FromMinutes(5)); // time message should be invisible to other clients.
```

# Service Bus

You'll install the following packages:
```xml
  <ItemGroup>
    <PackageReference Include="Azure.Messaging.ServiceBus" Version="7.14.0" />
  </ItemGroup>
```
These are  namespaces you need to send:
```
using Azure.Identity;
using Azure.Messaging.ServiceBus;
```
```
dotnet add package Azure.Messaging.ServiceBus
```
## Sending Messages
Create an `ServiceBusClient` and use a factory method to get a sender. Build up a `ServiceBusMessageBatch`.
```csharp
ServiceBusClient client = new ServiceBusClient(connectionString);
ServiceBusSender sender = client.CreateSender(queueName);

using ServiceBusMessageBatch messageBatch = await sender.CreateMessageBatchAsync();
...
messageBatch.TryAddMessage(new ServiceBusMessage($"Message {i}"))

```
Once you have the batch ready, send it.
```csharp
await sender.SendMessagesAsync(messageBatch);
```
Remember to use `Dispose` to clean up.

## Receiving Messages
Build up the `ServiceBusProcessor` object and target the same queue.
```csharp
ServiceBusClient client = new ServiceBusClient(connectionString);
ServiceBusProcessor processor = client.CreateProcessor(queueName, new ServiceBusProcessorOptions());
```
Ensure you're listening to process any messages and errors. `ProcessMessageEventArgs` and `ProcessErrorEventArgs` can be processed in the event args.
```csharp
processor.ProcessMessageAsync += MessageHandler;
processor.ProcessErrorAsync += ErrorHandler;
```

```csharp
await processor.StartProcessingAsync();
...
await processor.StopProcessingAsync();
```
Always remember to `Dispose`.

# Event Hubs

## Sender Code

You'll install the following packages:
```xml
  <ItemGroup>
    <PackageReference Include="Azure.Identity" Version="1.9.0" />
    <PackageReference Include="Azure.Messaging.EventHubs" Version="5.9.2" />
  </ItemGroup>
```
These are  namespaces you need to send:
```
using Azure.Identity;
using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;
```

Create an `EventHubProducerClient` to start sending event to Event Hub.
```csharp
EventHubProducerClient producerClient = new EventHubProducerClient(
    "robazeventhub-nsp.servicebus.windows.net",
    "robazeventhub-1",
    new DefaultAzureCredential());
```

Create an event batch which you can start adding events to.
```csharp
using EventDataBatch eventBatch = await producerClient.CreateBatchAsync();
```

Add events to the batch one by one. A loop creates a number of them.
```csharp
eventBatch.TryAdd(new EventData(Encoding.UTF8.GetBytes($"Event {i}")))
```
Finally send them off as a batch.
```csharp
await producerClient.SendAsync(eventBatch);
```
## Receiver Code

You'll install the following packages:
```xml
  <ItemGroup>
    <PackageReference Include="Azure.Identity" Version="1.9.0" />
    <PackageReference Include="Azure.Messaging.EventHubs" Version="5.9.2" />
    <PackageReference Include="Azure.Messaging.EventHubs.Processor" Version="5.9.2" />
    <PackageReference Include="Azure.Storage.Blobs" Version="12.16.0" />
  </ItemGroup>
```

These are the namespaces you need to receive:
```
using Azure.Identity;
using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Consumer;
using Azure.Messaging.EventHubs.Processor;
using Azure.Storage.Blobs;
```

This storage account will be used to create checkpoints on your partitions and it is expected to exist. It's passed into the constructor of the `EventProcessorClient`.
```csharp
BlobContainerClient storageClient = new BlobContainerClient(blobStorageUrl, new DefaultAzureCredential());
```

```csharp
// Create an event processor client to process events in the event hub
EventProcessorClient processor = new EventProcessorClient(storageClient, 
    EventHubConsumerClient.DefaultConsumerGroupName,
    "robazeventhub-nsp.servicebus.windows.net",
    "robazeventhub-1",
    new DefaultAzureCredential());

// Register handlers for processing events and handling errors
processor.ProcessEventAsync += ProcessEventHandler;
processor.ProcessErrorAsync += ProcessErrorHandler;
```

```csharp
await processor.StartProcessingAsync();
```

```csharp
await processor.StopProcessingAsync();
```

# Event Grid

You'll install the following packages:
```xml
  <ItemGroup>
    <PackageReference Include="Azure.Messaging.EventGrid" Version="4.11.0" />
  </ItemGroup>
```
These are  namespaces you need to send:
```
using Azure;
using Azure.Messaging.EventGrid;
```

```csharp
EventGridPublisherClient client = new EventGridPublisherClient(endpoint, credential);
```
Create a new variable named "firstEvent" of type `EventGridEvent`, and populate that variable with sample data...
```csharp
EventGridEvent firstEvent = new EventGridEvent(
    subject: @"\a\b\c\d",
    eventType: "Employees.Registration.New",
    dataVersion: "1.0",
    data: new
    {
        FullName = "Alba Sutton",
        Address = "4567 Pine Avenue, Edison, WA 97202"
    }
);
```
Asynchronously invoke the "EventGridPublisherClient.SendEventAsync" method using the "firstEvent" variable as a parameter
```csharp
await client.SendEventAsync(firstEvent);
```
## Egress
A subcription is made to another Azure Service or Webhook where the event will be sent.

# MSAL

```csharp
using Microsoft.Identity.Client;

namespace az204_msal
{
    class Program
    {
      ...
        public static async Task Main(string[] args)
        {
            var app = PublicClientApplicationBuilder
                .Create(_clientId)
                .WithAuthority(AzureCloudInstance.AzurePublic, _tenantId)
                .WithRedirectUri("http://localhost")
                .Build(); 

            string[] scopes = { "user.read" };
            AuthenticationResult result = await app.AcquireTokenInteractive(scopes).ExecuteAsync();

            Console.WriteLine($"Token:\t{result.AccessToken}");
        }
    }
}
```

# Redis

- [Source Content](https://learn.microsoft.com/en-us/training/modules/develop-for-azure-cache-for-redis/4-interact-redis-api) describes more common methods if you have time to revise.

Here is an example of a Redis connection string. The `abortConnect=False` means that the connection is created even if the backend server is not available.
```
[cache-name].redis.cache.windows.net:6380,password=[password-here],ssl=True,abortConnect=False
```

```csharp
using StackExchange.Redis;
```
`ConnectionMultiplexer` is optimized to manage connections efficiently and intended to be kept around while you need access to the cache. The Redis database is represented by the IDatabase type. You can retrieve one using the GetDatabase() method.
```csharp
using (var redisConnection = ConnectionMultiplexer.Connect(connectionString))
{
  IDatabase db = redisConnection.GetDatabase();
  ...
}
```

```csharp
bool wasSet = await database.StringSetAsync("favorite:flavor", "i-love-rocky-road");
```
Redis keys and values are binary safe. These same methods can be used to store binary data: `await database.StringSetAsync(binaryKey, binaryValue);`

```csharp
await database.KeyExpireAsync("favorite:flavor", TimeSpan.FromSeconds(10));
```

```csharp
bool exists = await database.KeyExistsAsync(binaryValue);
```

```csharp
database.KeyRename("favorite:flavor", "fav_flavor");
```

```csharp
RedisResult result = database.Execute("ping"); // returns "PONG"

var result2 = await database.ExecuteAsync("client", "list");
```

> Note: You can also serialize/deserialize complex JSON objects.

# Application Insights

- [Application Insights nuget package](https://www.nuget.org/packages/Microsoft.ApplicationInsights)
- [Get Metric](https://learn.microsoft.com/en-us/azure/azure-monitor/app/api-custom-events-metrics#getmetric)
```bash
dotnet add package Microsoft.ApplicationInsights --version 2.7.2
```

# Azure Content Delivery

```csharp
  CdnManagementClient cdn = new CdnManagementClient(new TokenCredentials(authResult.AccessToken))
      { SubscriptionId = subscriptionId };
```

List all profiles and endpoints in resource group.

```csharp
private static void ListProfilesAndEndpoints(CdnManagementClient cdn)
{
    var profileList = cdn.Profiles.ListByResourceGroup(resourceGroupName);
    foreach (Profile p in profileList)
    {
        var endpointList = cdn.Endpoints.ListByProfile(p.Name, resourceGroupName);

        foreach (Endpoint e in endpointList)
            Console.WriteLine("-{0} ({1})", e.Name, e.HostName);
    }
}
```

Create profiles and endpoints.
```csharp
ProfileCreateParameters profileParms =
    new ProfileCreateParameters() { Location = resourceLocation, Sku = new Sku(SkuName.StandardVerizon) };

cdn.Profiles.Create(profileName, profileParms, resourceGroupName);
```

```csharp
EndpointCreateParameters endpointParms =
    new EndpointCreateParameters()
    {
        Origins = new List<DeepCreatedOrigin>() { new DeepCreatedOrigin("Contoso", "www.contoso.com") },
        IsHttpAllowed = true,
        IsHttpsAllowed = true,
        Location = resourceLocation
    };

cdn.Endpoints.Create(endpointName, endpointParms, profileName, resourceGroupName);
```
Purge an endpoint
```csharp
cdn.Endpoints.PurgeContent(resourceGroupName, profileName, endpointName, new List<string>() { "/*" });
```

# Microsoft Graph

The Microsoft Graph client is simply a facade that results in a number of HTTPS requests being sent to MS GRAPH. Note the .NET code and the HTTPS requests that it ends up generating behind the scenes.

- [Source Content](https://learn.microsoft.com/en-us/training/modules/microsoft-graph/4-microsoft-graph-sdk)

These are  packages you need to send:
```
Microsoft.Graph
Microsoft.Graph.Beta
Microsoft.Graph.Core
```

```csharp
var scopes = new[] { "User.Read" };

// Multi-tenant apps can use "common",
// single-tenant apps must use the tenant ID from the Azure portal
var tenantId = "common";

// Value from app registration
var clientId = "YOUR_CLIENT_ID";

// using Azure.Identity;
var options = new TokenCredentialOptions
{
    AuthorityHost = AzureAuthorityHosts.AzurePublicCloud
};

// Callback function that receives the user prompt
// Prompt contains the generated device code that you must
// enter during the auth process in the browser
Func<DeviceCodeInfo, CancellationToken, Task> callback = (code, cancellation) => {
    Console.WriteLine(code.Message);
    return Task.FromResult(0);
};

// https://learn.microsoft.com/dotnet/api/azure.identity.devicecodecredential
var deviceCodeCredential = new DeviceCodeCredential(
    callback, tenantId, clientId, options);

var graphClient = new GraphServiceClient(deviceCodeCredential, scopes);
```

```csharp
// GET https://graph.microsoft.com/v1.0/me

var user = await graphClient.Me
    .Request()
    .GetAsync();
```

```csharp
// GET https://graph.microsoft.com/v1.0/me/messages?$select=subject,sender&$filter=<some condition>&orderBy=receivedDateTime

var messages = await graphClient.Me.Messages
    .Request()
    .Select(m => new {
        m.Subject,
        m.Sender
    })
    .Filter("<filter condition>")
    .OrderBy("receivedDateTime")
    .GetAsync();
```

```csharp
// DELETE https://graph.microsoft.com/v1.0/me/messages/{message-id}

string messageId = "AQMkAGUy...";
var message = await graphClient.Me.Messages[messageId]
    .Request()
    .DeleteAsync();
```

```csharp
// POST https://graph.microsoft.com/v1.0/me/calendars

var calendar = new Calendar
{
    Name = "Volunteer"
};

var newCalendar = await graphClient.Me.Calendars
    .Request()
    .AddAsync(calendar);
```

# Azure Identity - Acquiring Access Tokens

```
dotnet add package Azure.Identity

Azure.Security.KeyVault.Secrets
```

- [Source Content](https://learn.microsoft.com/en-us/training/modules/implement-managed-identities/5-acquire-access-token)

**Recommended** method is to use `DefaultAzureCredential` for an App-Only access token. Since `DefaultAzureCredential` attempts to authenticate via the listed mechanisms in the order listed: Environment, Managed Identity, Visual Studio, Azure CLI, Azure PowerShell, Interactive Browser.

```csharp
// Create a secret client using the DefaultAzureCredential
var client = new SecretClient(new Uri("https://myvault.vault.azure.net/"), new DefaultAzureCredential());
```

```csharp
// When deployed to an azure host, the default azure credential will 
// authenticate the specified user assigned managed identity.
string userAssignedClientId = "<your managed identity client Id>";

var credential = new DefaultAzureCredential(new DefaultAzureCredentialOptions 
	{ ManagedIdentityClientId = userAssignedClientId });

var blobClient = new BlobClient(
	new Uri("https://myaccount.blob.core.windows.net/mycontainer/myblob"
), credential);
```

```csharp
// Authenticate using managed identity if it is available; otherwise use the Azure CLI to authenticate.
var credential = new ChainedTokenCredential(new ManagedIdentityCredential(), 
	new AzureCliCredential());

var eventHubProducerClient = new EventHubProducerClient(
	"myeventhub.eventhubs.windows.net", "myhubpath", 
credential);
```