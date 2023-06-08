
# Implement interactive authentication using MSAL.NET

- [Source](https://learn.microsoft.com/en-us/training/modules/implement-authentication-by-using-microsoft-authentication-library/4-interactive-authentication-msal)


```csharp
IPublicClientApplication app = PublicClientApplicationBuilder.Create(clientId).Build();

var clientApp = PublicClientApplicationBuilder.Create(client_id)
    .WithAuthority(AzureCloudInstance.AzurePublic, tenant_id)
    .Build();
```

```csharp
IConfidentialClientApplication app = ConfidentialClientApplicationBuilder.Create(clientId).Build()
    .WithRedirectUri(redirectUri)
    .WithClientSecret(secret)
    .Build();

IConfidentialClientApplication app = ConfidentialClientApplicationBuilder.Create(clientId).Build()
    .WithRedirectUri(redirectUri)
    .WithCertificate(X509Certificate2_certificate)
    .Build();
```
# Stored Access Policy

- [Source](https://learn.microsoft.com/en-us/training/modules/implement-shared-access-signatures/4-stored-access-policies)

```csharp
BlobSignedIdentifier identifier = new BlobSignedIdentifier
{
    Id = "stored access policy identifier",
    AccessPolicy = new BlobAccessPolicy
    {
        ExpiresOn = DateTimeOffset.UtcNow.AddHours(1),
        Permissions = "rw"
    }
};

blobContainer.SetAccessPolicy(permissions: new BlobSignedIdentifer[] { identifer });
```

```bash
az storage container policy create \
    --name <stored access policy identifier> \
    --container-name <container name> \
    --start <start time UTC datetime> \
    --expiry <expiry time UTC datetime> \
    --permissions <(a)dd, (c)reate, (d)elete, (l)ist, (r)ead, or (w)rite> \
    --account-key <storage account key> \
    --account-name <storage account name> \
```

# Microsoft Graph

- [Source](https://learn.microsoft.com/en-us/training/modules/microsoft-graph/4-microsoft-graph-sdk)

```csharp
var scopes = new[] { "User.Read" };
var tenantId = "common";
var clientId = "YOUR_CLIENT_ID";

var options = new TokenCredentialOptions
{
    AuthorityHost = AzureAuthorityHosts.AzurePublicCloud
};

Func<DeviceCodeInfo, CancellationToken, Task> callback = (code, cancellation) => {
    Console.WriteLine(code.Message);
    return Task.FromResult(0);
};

var deviceCodeCredential = new DeviceCodeCredential(callback, ternantId, clientId, options);
var graphClient = new GraphServiceClient(deviceCodeCredential, scopes);
```


```csharp
var user = await graphClient.Me.Request().GetAsync();

var messages = await graphClient.Me.Messages
    .Request()
    .Select(m => new {
        m.Subject,
        m.Sender
    })
    .Filter("filter-condition")
    .OrderBy("receivedDatTime")
    .GetAsync();
```