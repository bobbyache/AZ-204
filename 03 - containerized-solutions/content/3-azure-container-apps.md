Azure Container Apps provides the flexibility you need with a serverless container service built for microservice applications and robust autoscaling capabilities without the overhead of managing complex infrastructure.

# Explore Azure Container Apps

Azure Container Apps enables you to run microservices and containerized applications on a serverless platform that runs on top of Azure Kubernetes Service. Common uses of Azure Container Apps include:

- Deploying API endpoints
- Hosting background processing applications
- Handling event-driven processing
- Running microservices

Applications built on Azure Container Apps can dynamically scale based on: HTTP traffic, event-driven processing, CPU or memory load, and any KEDA-supported scaler.

With Azure Container Apps, you can:

- Run multiple container revisions and manage the container app's application lifecycle.
- Autoscale your apps based on any KEDA-supported scale trigger. Most applications can scale to zero. (Applications that scale on CPU or memory load can't scale to zero.)
- Enable HTTPS ingress without having to manage other Azure infrastructure.
- Split traffic across multiple versions of an application for Blue/Green deployments and A/B testing scenarios.
- Use internal ingress and service discovery for secure internal-only endpoints with built-in DNS-based service discovery.
- Build microservices with Dapr and access its rich set of APIs.
- Run containers from any registry, public or private, including Docker Hub and Azure Container Registry (ACR).
- Use the Azure CLI extension, Azure portal or ARM templates to manage your applications.
- Provide an existing virtual network when creating an environment for your container apps.
- Securely manage secrets directly in your application.
- Monitor logs using Azure Log Analytics.

## Azure Container Apps environments

Individual container apps are deployed to a single Container Apps environment, which acts as a secure boundary around groups of container apps. Container Apps in the same environment are deployed in the same virtual network and write logs to the same Log Analytics workspace. You may provide an existing virtual network when you create an environment.

Reasons to deploy container apps to the same environment include situations when you need to:

Manage related services

- Deploy different applications to the same virtual network
- Instrument Dapr applications that communicate via the Dapr service invocation API
- Have applications to share the same Dapr configuration
- Have applications share the same log analytics workspace

Reasons to deploy container apps to different environments include situations when you want to ensure:

- Two applications never share the same compute resources
- Two Dapr applications can't communicate via the Dapr service invocation API

## Microservices with Azure Container Apps

Microservice architectures allow you to independently develop, upgrade, version, and scale core areas of functionality in an overall system. Azure Container Apps provides the foundation for deploying microservices featuring:

- Independent scaling, versioning, and upgrades
- Service discovery
- Native Dapr integration

## Dapr integration

When you implement a system composed of microservices, function calls are spread across the network. To support the distributed nature of microservices, you need to account for failures, retries, and timeouts. While Container Apps features the building blocks for running microservices, use of Dapr provides an even richer microservices programming model. Dapr includes features like observability, pub/sub, and service-to-service invocation with mutual TLS, retries, and more.

---

# Explore containers in Azure Container Apps

Azure Container Apps manages the details of Kubernetes and container orchestration for you. Containers in Azure Container Apps can use any runtime, programming language, or development stack of your choice. Azure Container Apps supports any Linux-based x86-64 (linux/amd64) container image. There's no required base container image, and if a container crashes it automatically restarts.

## Configuration

The following code is an example of the containers array in the properties.template section of a container app resource template. The excerpt shows some of the available configuration options when setting up a container when using Azure Resource Manager (ARM) templates. Changes to the template ARM configuration section trigger a new container app revision.

## Multiple containers

You can define multiple containers in a single container app to implement the sidecar pattern. The containers in a container app share hard disk and network resources and experience the same application lifecycle.

Examples of sidecar containers include:

An agent that reads logs from the primary app container on a shared volume and forwards them to a logging service.
A background process that refreshes a cache used by the primary app container in a shared volume.
Running multiple containers in a single container app is an advanced use case. In most situations where you want to run multiple containers, such as when implementing a microservice architecture, deploy each service as a separate container app.

To run multiple containers in a container app, add more than one container in the containers array of the container app template.

## Container registries

You can deploy images hosted on private registries by providing credentials in the Container Apps configuration.

To use a container registry, you define the required fields in registries array in the properties.configuration section of the container app resource template. The passwordSecretRef field identifies the name of the secret in the secrets array name where you defined the password. With the registry information added, the saved credentials can be used to pull a container image from the private registry when your app is deployed.

## Limitations

Azure Container Apps has the following limitations:

- Privileged containers: Azure Container Apps can't run privileged containers. If your program attempts to run a process that requires root access, the application inside the container experiences a runtime error.
- Operating system: Linux-based (linux/amd64) container images are required.

---

# Implement authentication and authorization in Azure Container Apps

Azure Container Apps provides built-in authentication and authorization features to secure your external ingress-enabled container app with minimal or no code. The built-in authentication feature for Container Apps can save you time and effort by providing out-of-the-box authentication with federated identity providers, allowing you to focus on the rest of your application.

- Azure Container Apps provides access to various built-in authentication providers.
- The built-in auth features don’t require any particular language, SDK, security expertise, or even any code that you have to write.

This feature should only be used with HTTPS. Ensure allowInsecure is disabled on your container app's ingress configuration. You can configure your container app for authentication with or without restricting access to your site content and APIs.

- To restrict app access only to authenticated users, set its Restrict access setting to Require authentication.
- To authenticate but not restrict access, set its Restrict access setting to Allow unauthenticated access.

Identity providers

Container Apps uses federated identity, in which a third-party identity provider manages the user identities and authentication flow for you. The following identity providers are available by default: Microsoft Identity Platform, Facebook, GitHub, Google, Twitter, Any OpenID Connect provider. When you use one of these providers, the sign-in endpoint is available for user authentication and authentication token validation from the provider. You can provide your users with any number of these provider options.

## Feature architecture

The authentication and authorization middleware component is a feature of the platform that runs as a sidecar container on each replica in your application. When enabled, every incoming HTTP request passes through the security layer before being handled by your application.

### The platform middleware handles several things for your app:

- Authenticates users and clients with the specified identity provider(s)
- Manages the authenticated session
- Injects identity information into HTTP request headers

The authentication and authorization module runs in a separate container, isolated from your application code. As the security container doesn't run in-process, no direct integration with specific language frameworks is possible. However, relevant information your app needs is provided in request headers.

## Authentication flow

The authentication flow is the same for all providers, but differs depending on whether you want to sign in with the provider's SDK:

- Without provider SDK (server-directed flow or server flow): The application delegates federated sign-in to Container Apps. Delegation is typically the case with browser apps, which presents the provider's sign-in page to the user.
- With provider SDK (client-directed flow or client flow): The application signs users in to the provider manually and then submits the authentication token to Container Apps for validation. This approach is typical for browser-less apps that don't present the provider's sign-in page to the user. An example is a native mobile app that signs users in using the provider's SDK.

---

# Manage revisions and secrets in Azure Container Apps

Azure Container Apps implements container app versioning by creating revisions. A revision is an immutable snapshot of a container app version. You can use revisions to release a new version of your app, or quickly revert to an earlier version of your app. New revisions are created when you update your application with revision-scope changes. You can also update your container app based on a specific revision.

You can control which revisions are active, and the external traffic that is routed to each active revision. Revision names are used to identify a revision, and in the revision's URL. You can customize the revision name by setting the revision suffix.

By default, Container Apps creates a unique revision name with a suffix consisting of a semi-random string of alphanumeric characters. For example, for a container app named album-api, setting the revision suffix name to 1st-revision would create a revision with the name album-api--1st-revision. You can set the revision suffix in the ARM template, through the Azure CLI az containerapp create and az containerapp update commands, or when creating a revision via the Azure portal.

## Updating your container app

With the "az containerapp update" command you can modify environment variables, compute resources, scale parameters, and deploy a different image. If your container app update includes revision-scope changes, a new revision is generated. You can list all revisions associated with your container app with the "az containerapp revision list" command.

## Manage secrets in Azure Container Apps

Azure Container Apps allows your application to securely store sensitive configuration values. Once secrets are defined at the application level, secured values are available to container apps. Specifically, you can reference secured values inside scale rules.

Secrets are scoped to an application, outside of any specific revision of an application.
Adding, removing, or changing secrets doesn't generate new revisions.
Each application revision can reference one or more secrets.
Multiple revisions can reference the same secret(s).
An updated or deleted secret doesn't automatically affect existing revisions in your app. When a secret is updated or deleted, you can respond to changes in one of two ways:

- Deploy a new revision. 
- Restart an existing revision.

Before you delete a secret, deploy a new revision that no longer references the old secret. Then deactivate all revisions that reference the secret.

Container Apps doesn't support Azure Key Vault integration. Instead, enable managed identity in the container app and use the Key Vault SDK in your app to access secrets.

## Defining secrets

When you create a container app, secrets are defined using the `--secrets` parameter.

- The parameter accepts a space-delimited set of name/value pairs.
- Each pair is delimited by an equals sign (=).

In the example below a connection string to a queue storage account is declared in the `--secrets` parameter. The value for queue-connection-string comes from an environment variable named `$CONNECTION_STRING`.

After declaring secrets at the application level, you can reference them in environment variables when you create a new revision in your container app. When an environment variable references a secret, its value is populated with the value defined in the secret. To reference a secret in an environment variable in the Azure CLI, set its value to `secretref:`, followed by the name of the secret.

The following example shows an application that declares a connection string at the application level. This connection is referenced in a container environment variable.

---

# Explore Dapr integration with Azure Container Apps

The Distributed Application Runtime (Dapr) is a set of incrementally adoptable features that simplify the authoring of distributed, microservice-based applications. Dapr provides capabilities for enabling application intercommunication through messaging via pub/sub or reliable and secure service-to-service calls.

Dapr is an open source, Cloud Native Computing Foundation (CNCF) project. The CNCF is part of the Linux Foundation and provides support, oversight, and direction for fast-growing, cloud native projects. As an alternative to deploying and managing the Dapr OSS project yourself, the Container Apps platform:

- Provides a managed and supported Dapr integration
- Handles Dapr version upgrades seamlessly
- Exposes a simplified Dapr interaction model to increase developer productivity

## Dapr APIs

- Service-to-service invocation discovers services and perform reliable, direct service-to-service calls with automatic mTLS authentication and encryption.
- State management provides state management capabilities for transactions and CRUD operations.
- Pub/sub allows publisher and subscriber container apps to intercommunicate via an intermediary message broker.
- Bindings trigger your applications based on events
- Dapr actors are message-driven, single-threaded, units of work designed to quickly scale. For example, in burst-heavy workload situations.
- Observability sends tracing information to an Application Insights backend.
- Secrets access secrets from your application code or reference secure values in your Dapr components.

## Dapr enablement

You can configure Dapr using various arguments and annotations based on the runtime context. Azure Container Apps provides three channels through which you can configure Dapr:

- Container Apps CLI
- Infrastructure as Code (IaC) templates, as in Bicep or Azure Resource Manager (ARM) templates
- The Azure portal

## Dapr components and scopes

Dapr uses a modular design where functionality is delivered as a component. The use of Dapr components is optional and dictated exclusively by the needs of your application.

Dapr components in container apps are environment-level resources that:

- Can provide a pluggable abstraction model for connecting to supporting external services.
- Can be shared across container apps or scoped to specific container apps.
- Can use Dapr secrets to securely retrieve configuration metadata.

By default, all Dapr-enabled container apps within the same environment load the full set of deployed components. To ensure components are loaded at runtime by only the appropriate container apps, application scopes should be used.