- [Source-Lab](https://microsoftlearning.github.io/AZ-204-DevelopingSolutionsforMicrosoftAzure/Instructions/Labs/AZ-204_lab_12.html)

### Register CDN Provider

```bash
if (-not (az provider show --namespace Microsoft.CDN --query "registrationState")) {
    Write-Host "Microsoft.CDN is NOT yet registered... registering..."
    az provider register --namespace Microsoft.CDN
    Write-Host "Microsoft.CDN is now registered for this subscription"
}
```

# Redis Cache

> Note: Currently the library being referred to has been deprecated.

- [Original Source](https://learn.microsoft.com/en-us/training/modules/develop-for-storage-cdns/4-azure-cdn-libraries-dotnet)
- [Official Documentation]()
- [GitHub Project]()
- [Create in Portal]()

# Add the Package

```
dotnet new console -o Cdn
dotnet add package Microsoft.Azure.Management.Cdn.Fluent
```

# Example Usage

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