https://learn.microsoft.com/en-us/training/modules/develop-for-azure-cache-for-redis/4-interact-redis-api

https://learn.microsoft.com/en-us/training/modules/develop-for-azure-cache-for-redis/5-console-app-azure-cache-redis

- [Create in Portal](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/quickstart-create-redis)

- [Original Source](https://learn.microsoft.com/en-us/training/modules/develop-for-azure-cache-for-redis/4-interact-redis-api)
- [Official Documentation](https://stackexchange.github.io/StackExchange.Redis/)
- [GitHub Project](https://github.com/StackExchange/StackExchange.Redis)


# Redis (node.js)

- Always changed your Redis Port.
- Install Redis Client Library: `npm install redis`
- [Install](https://www.npmjs.com/package/dotenv) `dotenv` for environment variables: `npm install dotenv --save`
- Remember to always change your Redis port for better security.
- [Install Redis command-line tool with Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-redis-cli-tool)

- [Redis Commands](https://redis.io/commands/)

## Get Environment variables

To get the host name navigate to Settings -> Properties and copy the Host Name. To get the access key navigate to Settings -> Access Keys and fetch Primary (key).

Ensure that you populate the `.env` file settings with these values.

Double check that the port matches.

```bash
az redis show [--ids]
              [--name]
              [--resource-group]
              [--subscription]

az redis list-keys [--ids]
                   [--name]
                   [--resource-group]
                   [--subscription]
```

### .env File
```
AZURE_CACHE_FOR_REDIS_ACCESS_KEY=Hinyr5mjOuOhSXkDYnQby7BM7SCSrAl3UAzCaM2cReg=
AZURE_CACHE_FOR_REDIS_HOST_NAME=robaz-rediscache.redis.cache.windows.net
```

### redis.js

```javascript
require('dotenv').config();
const redis = require("redis");

// Environment variables for cache
const cacheHostName = process.env.AZURE_CACHE_FOR_REDIS_HOST_NAME;
const cachePassword = process.env.AZURE_CACHE_FOR_REDIS_ACCESS_KEY;

if (!cacheHostName) throw Error("AZURE_CACHE_FOR_REDIS_HOST_NAME is empty");
if (!cachePassword) throw Error("AZURE_CACHE_FOR_REDIS_ACCESS_KEY is empty");

async function testCache() {
  // Connection configuration
  const cacheConnection = redis.createClient({
    // rediss for TLS
    url: `rediss://${cacheHostName}:6380`,
    password: cachePassword,
  });

  // Connect to Redis
  await cacheConnection.connect();

  // PING command
  console.log("\nCache command: PING");
  console.log("Cache response : " + (await cacheConnection.ping()));

  // GET
  console.log("\nCache command: GET Message");
  console.log("Cache response : " + (await cacheConnection.get("Message")));

  // SET
  console.log("\nCache command: SET Message");
  console.log(
    "Cache response : " +
      (await cacheConnection.set(
        "Message",
        "Hello! The cache is working from Node.js!"
      ))
  );

  // GET again
  console.log("\nCache command: GET Message");
  console.log("Cache response : " + (await cacheConnection.get("Message")));

  // Client list, useful to see if connection list is growing...
  console.log("\nCache command: CLIENT LIST");
  console.log(
    "Cache response : " +
      (await cacheConnection.sendCommand(["CLIENT", "LIST"]))
  );

  // Disconnect
  cacheConnection.disconnect();

  return "Done";
}

testCache()
  .then((result) => console.log(result))
  .catch((ex) => console.log(ex));

```

# Redis Cache (.NET)

- [Original Source](https://learn.microsoft.com/en-us/training/modules/develop-for-azure-cache-for-redis/4-interact-redis-api)
- [Official Documentation](https://stackexchange.github.io/StackExchange.Redis/)
- [GitHub Project](https://github.com/StackExchange/StackExchange.Redis)
- [Create in Portal](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/quickstart-create-redis)
- [Redis Azure Documentation](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/)
- [ASP.NET Core App](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-web-app-aspnet-core-howto)
- [Quickstart: Use Azure Cache for Redis in .NET Core](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-dotnet-core-quickstart)



## Add the Package

```
dotnet new console -o Rediscache
dotnet add package StackExchange.Redis
```

## Example Usage

```csharp
using (var cache = ConnectionMultiplexer.Connect(connectionString))
{
    IDatabase db = cache.GetDatabase();

    // Snippet below executes a PING to test the server connection
    var result = await db.ExecuteAsync("ping");
    Console.WriteLine($"PING = {result.Type} : {result}");

    // Call StringSetAsync on the IDatabase object to set the key "test:key" to the value "100"
    bool setValue = await db.StringSetAsync("test:key", "100");
    Console.WriteLine($"SET: {setValue}");

    // StringGetAsync retrieves the value for the "test" key
    string getValue = await db.StringGetAsync("test:key");
    Console.WriteLine($"GET: {getValue}");
}
```

