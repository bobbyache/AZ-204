# Summary

The Microsoft identity platform provides an authorization model for applications that integrates with it, granting users and administrators control over data access. It implements the OAuth 2.0 authorization protocol, allowing third-party apps to access web-hosted resources on behalf of users. Resources, such as Microsoft Graph, Microsoft 365 Mail API, and Azure Key Vault, have unique identifiers known as application ID URIs. Permissions, represented as string values, can be requested by apps using scopes. Scopes define sets of permissions that can be divided into smaller chunks, enabling apps to request only the necessary permissions. Delegated permissions are used when apps have a signed-in user, while app-only access permissions are utilized by background services. Consent plays a crucial role in granting access to resources, and there are three types: static user consent, incremental and dynamic user consent, and admin consent. Admin consent is required for high-privilege permissions, ensuring control over privileged data access.

# Term Dictionary


- **Azure Key Vault**:
  - Summary: Azure Key Vault is a cloud-based service by Microsoft that allows for secure storage and management of cryptographic keys, secrets, and certificates. It helps safeguard sensitive information and provides centralized control over access.
  - Usage: Azure Key Vault can be used to securely store and manage keys, secrets, and certificates used in applications and services hosted on Azure. It provides secure key management and simplifies the process of protecting sensitive data.
  - Official Website: [Azure Key Vault](https://azure.microsoft.com/services/key-vault/)
  - YouTube Video: [Azure Key Vault - Introduction and Overview](https://www.youtube.com/watch?v=qgeKYNvMHZU)

- **Microsoft Graph**:
  - Summary: Microsoft Graph is an API (Application Programming Interface) provided by Microsoft that allows developers to access a wide range of Microsoft 365 services and data, including users, messages, calendars, files, and more.
  - Usage: Developers can use Microsoft Graph to build applications that interact with Microsoft 365 services and access data across multiple Microsoft products and services. It provides a unified endpoint and consistent programming model for accessing various resources and data within the Microsoft ecosystem.
  - Official Website: [Microsoft Graph](https://docs.microsoft.com/graph/)
  - YouTube Video: [Introduction to Microsoft Graph API](https://www.youtube.com/watch?v=OVW4s0B3JIM)

- **Microsoft 365 Mail API**:
  - Summary: Microsoft 365 Mail API is an API that allows developers to programmatically access and interact with Microsoft 365 mail-related services, including email messages, folders, attachments, and more.
  - Usage: Developers can use the Microsoft 365 Mail API to integrate email functionality into their applications, such as sending, receiving, and managing email messages on behalf of users. It provides programmatic access to mail-related features and data within the Microsoft 365 ecosystem.
  - Official Website: [Microsoft 365 Mail API Reference](https://docs.microsoft.com/graph/api/resources/mail-api-overview?view=graph-rest-1.0)
  - YouTube Video: [Microsoft Graph: Microsoft 365 Mail, Calendar, and Contacts APIs](https://www.youtube.com/watch?v=NMzDwFUIWyM)

- **OAuth 2.0**:
  - Summary: OAuth 2.0 is an authorization framework that allows third-party applications to obtain limited access to a user's protected resources on a web service without requiring their credentials. It provides a secure and standardized way to grant permissions and access rights to external applications.
  - Usage: OAuth 2.0 is widely used for authentication and authorization in various web and mobile applications. It enables users to grant limited access to their data stored on a service to authorized third-party applications without sharing their login credentials. OAuth 2.0 is used by the Microsoft identity platform to facilitate secure access to web-hosted resources.
  - Official Website: [OAuth 2.0](https://oauth.net/2/)
  - YouTube Video: [OAuth 2.0 and OpenID Connect (in plain English)](https://www.youtube.com/watch?v=996OiexHze0)

