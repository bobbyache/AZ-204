Azure Blob Storage is a cloud-based object storage solution by Microsoft, optimized for storing large amounts of unstructured data. It offers a range of use cases, including serving files to browsers, distributed file access, video and audio streaming, log file writing, data backup and restore, disaster recovery, archiving, and analysis by on-premises or Azure-hosted services.

Users can access Blob storage through HTTP/HTTPS using the Azure Storage REST API, Azure PowerShell, Azure CLI, or Azure Storage client library. Azure Storage accounts serve as top-level containers, providing a unique namespace accessible globally.

Two performance levels are available: standard (recommended for most scenarios) and premium (higher performance using solid-state drives).

Blob data can be stored in different access tiers: Hot (frequent access), Cool (infrequent access), and Archive (tolerating retrieval latency). Switching between access tiers is possible to adapt to changing usage patterns.

# Resource Types

Azure Blob storage offers three types of resources: storage accounts, containers, and blobs. A storage account provides a unique namespace in Azure for data storage, with each object having an address based on the account name and Azure Storage blob endpoint.

Containers are used to organize collections of blobs, similar to directories in a file system, and a storage account can have unlimited containers, each capable of storing an unlimited number of blobs. Container names must adhere to specific naming rules. 

Azure Storage supports three types of blobs: 
- block blobs, which store text and binary data in individually manageable blocks; - append blobs, optimized for append operations and suitable for logging data; 
- and page blobs, designed for random access files up to 8 TB in size, often used as virtual hard drives for Azure virtual machines.

Overall, Azure Blob storage provides a flexible and scalable solution for organizing and storing data in the cloud.

# Azure Storage Security

Azure Storage provides a robust set of security features, including automatic encryption of all data at rest using Storage Service Encryption (SSE), support for Azure Active Directory (Azure AD) and Role-Based Access Control (RBAC), secure data transit options, encryption of Azure virtual machine disks with Azure Disk Encryption, and delegated access through shared access signatures. Encryption is enabled by default for all storage accounts, and it covers all Azure Storage resources, ensuring data protection without impacting performance. Users can choose to rely on Microsoft-managed keys or manage their own encryption keys, with options for customer-managed keys for the entire storage account or customer-provided keys for granular control over Blob storage operations. Overall, Azure Storage offers comprehensive security capabilities to help developers build secure applications and meet organizational security and compliance requirements.

# Life-cycle policies

A lifecycle management policy is a collection of rules in a JSON document. Each rule consists of a filter set and an action set. The filter set limits rule actions to specific objects within a container or based on object names. The action set applies tier or delete actions to the filtered objects. A policy requires at least one rule and can have up to 100 rules. Filters in lifecycle management narrow down the scope of rule actions. Actions can include tiering and deletion of blobs and blob snapshots. Run conditions in lifecycle management are based on age, using the last modified time for base blobs and the snapshot creation time for blob snapshots

# Rehydration

When a blob is in the archive access tier, it is offline and cannot be read or modified. To access or modify data in an archived blob, it needs to be rehydrated to an online tier, such as the hot or cool tier.

There are two options for rehydrating an archived blob: copying it to an online tier or changing its access tier. 

Copying involves creating a new blob in the hot or cool tier, while changing the access tier directly modifies the existing blob. Rehydrating a blob from the archive tier may take several hours, and larger blobs are recommended to be rehydrated for optimal performance. Rehydration priority can be set as standard or high, with high priority requests being prioritized. 

Copying an archived blob to an online tier requires creating a new blob with a different name or in a different container, and overwriting the source blob is not possible. 

Changing a blob's access tier to an online tier can be done by calling Set Blob Tier, but once initiated, the process cannot be canceled. The access tier setting remains as archived during the rehydration process until it is complete. 

It's important to note that changing a blob's tier does not affect its last modified time, and if a lifecycle management policy is in place, the blob may be moved back to the archive tier based on the policy's threshold.