Caching is a common technique that aims to improve the performance and scalability of a system. It does this by temporarily copying frequently accessed data to fast storage that's located close to the application. If this fast data storage is located closer to the application than the original source, then caching can significantly improve response times for client applications by serving data more quickly.

Azure Cache for Redis provides an in-memory data store based on the Redis software. Redis improves the performance and scalability of an application that uses backend data stores heavily. It's able to process large volumes of application requests by keeping frequently accessed data in the server memory, which can be written to and read from quickly. Redis brings a critical low-latency and high-throughput data storage solution to modern applications.

Azure Cache for Redis offers both the Redis open-source (OSS Redis) and a commercial product from Redis Labs (Redis Enterprise) as a managed service. It provides secure and dedicated Redis server instances and full Redis API compatibility. The service is operated by Microsoft, hosted on Azure, and usable by any application within or outside of Azure.

# Key Scenarios

Azure Cache for Redis improves application performance by supporting common application architecture patterns. Some of the most common include the following patterns: Data cache, Content cache, Session store, Job and message queuing, and Distributed transactions.


Data cache pattern - Databases are often too large to load directly into a cache. It's common to use the cache-aside pattern to load data into the cache only as needed. When the system makes changes to the data, the system can also update the cache, which is then distributed to other clients.

Content cache pattern - Many web pages are generated from templates that use static content such as headers, footers, banners. These static items shouldn't change often. Using an in-memory cache provides quick access to static content compared to backend datastores.

Session store pattern - This pattern is commonly used with shopping carts and other user history data that a web application might associate with user cookies. Storing too much in a cookie can have a negative effect on performance as the cookie size grows and is passed and validated with every request. A typical solution uses the cookie as a key to query the data in a database. Using an in-memory cache, like Azure Cache for Redis, to associate information with a user is faster than interacting with a full relational database.

Job and message queuing pattern - Applications often add tasks to a queue when the operations associated with the request take time to execute. Longer running operations are queued to be processed in sequence, often by another server. This method of deferring work is called task queuing.

Distributed transactions pattern - Applications sometimes require a series of commands against a backend data-store to execute as a single atomic operation. All commands must succeed, or all must be rolled back to the initial state. Azure Cache for Redis supports executing a batch of commands as a single transaction.



# Service Tiers

Azure Cache for Redis is available in these tiers: Basic, Standard, Premium, Enterprise, Enterprise Flash

Basic Tier - An OSS Redis cache running on a single VM. This tier has no service-level agreement (SLA) and is ideal for development/test and noncritical workloads.

Standard Tier - An OSS Redis cache running on two VMs in a replicated configuration.

Premium Tier - High-performance OSS Redis caches. This tier offers higher throughput, lower latency, better availability, and more features. Premium caches are deployed on more powerful VMs compared to the VMs for Basic or Standard caches.

Enterprise Tier - High-performance caches powered by Redis Labs' Redis Enterprise software. This tier supports Redis modules including RediSearch, RedisBloom, and RedisTimeSeries. Also, it offers even higher availability than the Premium tier.

Enterprise Flash Tier - Cost-effective large caches powered by Redis Labs' Redis Enterprise software. This tier extends Redis data storage to nonvolatile memory, which is cheaper than DRAM, on a VM. It reduces the overall per-GB memory cost.l state. Azure Cache for Redis supports executing a batch of commands as a single transaction.

# Redis

You can create a Redis cache using the Azure portal, the Azure CLI, or Azure PowerShell.

There are several parameters you need to decide in order to configure the cache properly for your purposes.

Name Property - The Redis cache needs a globally unique name. The name has to be unique within Azure because it's used to generate a public-facing URL to connect and communicate with the service. The name must be between 1 and 63 characters, composed of numbers, letters, and the '-' character. The cache name can't start or end with the '-' character, and consecutive '-' characters aren't valid.

Location Property - You should always place your cache instance and your application in the same region. Connecting to a cache in a different region can significantly increase latency and reduce reliability. If you're connecting to the cache outside of Azure, then select a location close to where the application consuming the data is running.

Cache type Property - The tier determines the size, performance, and features that are available for the cache. For more information, visit Azure Cache for Redis pricing.

Microsoft recommends you always use Standard tier or higher for production systems. The Basic tier is a single node system with no data replication and no SLA.

With the Premium, Enterprise, and Enterprise Flash tiers you can implement clustering to automatically split your dataset among multiple nodes. To implement clustering, you specify the number of shards to a maximum of 10. The cost incurred is the cost of the original node, multiplied by the number of shards.

# Accessing the Redis Instance

Redis has a command-line tool for interacting with an Azure Cache for Redis as a client. The tool is available for Windows platforms by downloading the Redis command-line tools for Windows. If you want to run the command-line tool on another platform, download Azure Cache for Redis from https://redis.io/download.

Redis supports a set of known commands. A command is typically issued as COMMAND parameter1 parameter2 parameter3.

# Expiration Times

Caching is important because it allows us to store commonly used values in memory. However, we also need a way to expire values when they're stale. In Redis this is done by applying a time to live (TTL) to a key.

When the TTL elapses, the key is automatically deleted, exactly as if the DEL command were issued. Here are some notes on TTL expirations.

- Expirations can be set using seconds or milliseconds precision.
- The expire time resolution is always 1 millisecond.
- Information about expires are replicated and persisted on disk, the time virtually passes when your Redis server remains stopped (this means that Redis saves the date when a key expires).

# Accessing a Redis cache from a client

To connect to an Azure Cache for Redis instance, you need several pieces of information. Clients need the host name, port, and an access key for the cache. You can retrieve this information in the Azure portal through the Settings > Access Keys page.

- The host name is the public Internet address of your cache, which was created using the name of the cache. For example, sportsresults.redis.cache.windows.net.
- The access key acts as a password for your cache. There are two keys created: primary and secondary. You can use either key, two are provided in case you need to change the primary key. You can switch all of your clients to the secondary key, and regenerate the primary key. This would block any applications using the original primary key. Microsoft recommends periodically regenerating the keys - much like you would your personal passwords.

Your access keys should be considered confidential information, treat them like you would a password. Anyone who has an access key can perform any operation on your cache!

# Interact

A popular high-performance Redis client for the .NET language is StackExchange.Redis. The package is available through NuGet and can be added to your .NET code using the command line or IDE. Following are examples of how to use the client.

Recall that we use the host address, port number, and an access key to connect to a Redis server. Azure also offers a connection string for some Redis clients that bundles this data together into a single string.

The main connection object in StackExchange.Redis is the StackExchange.Redis.ConnectionMultiplexer class. This object abstracts the process of connecting to a Redis server (or group of servers). It's optimized to manage connections efficiently and intended to be kept around while you need access to the cache.

You create a ConnectionMultiplexer instance using the static ConnectionMultiplexer.Connect or ConnectionMultiplexer.ConnectAsync method, passing in either a connection string or a ConfigurationOptions object.

The Redis database is represented by the IDatabase type. You can retrieve one using the GetDatabase() method.

The object returned from GetDatabase is a lightweight object, and does not need to be stored. Only the ConnectionMultiplexer needs to be kept alive.

The StringSet method returns a bool indicating whether the value was set (true) or not (false). We can then retrieve the value with the StringGet method.

Recall that Redis keys and values are binary safe. These same methods can be used to store binary data. There are implicit conversion operators to work with byte[] types so you can work with the data naturally.

StackExchange.Redis represents keys using the RedisKey type. This class has implicit conversions to and from both string and byte[], allowing both text and binary keys to be used without any complication. Values are represented by the RedisValue type. As with RedisKey, there are implicit conversions in place to allow you to pass string or byte[].

The IDatabase interface includes several other methods to work with the Redis cache. There are methods to work with hashes, lists, sets, and ordered sets.

The IDatabase object has an Execute and ExecuteAsync method that can be used to pass textual commands to the Redis server.

The Execute and ExecuteAsync methods return a RedisResult object that is a data holder that includes two properties: Type and IsNull.

Redis is oriented around binary safe strings, but you can cache off object graphs by serializing them to a textual format - typically XML or JSON.