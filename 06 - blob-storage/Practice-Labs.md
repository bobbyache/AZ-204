# Enable static website hosting

https://learn.microsoft.com/en-us/training/modules/explore-azure-blob-storage/5-blob-storage-static-website

# Work with Azure Blob Storage

https://learn.microsoft.com/en-us/training/modules/work-azure-blob-storage/1-introduction

# Implement Blob Storage Lifecycle Policies

https://learn.microsoft.com/en-us/training/modules/manage-azure-blob-storage-lifecycle/4-add-policy-blob-storage


# Storage Lifecycle Policy

Each rule definition includes a filter set and an action set. The filter set limits rule actions to a certain set of objects within a container or objects names. The action set applies the tier or delete actions to the filtered set of objects.

The following sample rule filters the account to run the actions on objects that exist inside container1 and start with foo.

Tier blob to cool tier 30 days after last modification
Tier blob to archive tier 90 days after last modification
Delete blob 2,555 days (seven years) after last modification
Delete blob snapshots 90 days after snapshot creation

```json
{
    "rules": [
        {
            "name": "ruleFoo",
            "enabled": true,
            "type": "Lifecycle",
            "definition": {
                "filters": {
                    "blobTypes": [ "blockBlob" ],
                    "prefixMatch": "container1/foo"
                },
                "actions": {
                    "baseBlob": {
                        "tierToCool": { "daysAfterModificationGreaterThan": 30 },
                        "tierToArchive": { "daysAfterModificationGreaterThan": 90 },
                        "delete": { "daysAfterModificationGreaterThan": 2555 }
                    },
                    "snapShot": {
                        "delete": { "daysAfterCreationGreaterThan": 90 }
                    }
                }
            }
        }
    ]
}
```

# Move blob between containers and storage accounts
Download the [tool from here](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10).

Here are some labs:

- [AzCopy](https://www.udemy.com/course/70532-azure/learn/lecture/32254716#overview) without having to download and then upload.
- [Use AZCopy to copy files to Storage Accounts](https://app.exampro.co/student/material/az-204/2527)
- [Interact with blob storage through an SDK](https://app.exampro.co/student/material/az-204/4246)

- [Use Visual Studio](https://www.udemy.com/course/70532-azure/learn/lecture/32254726#overview)

- [Retrieve and create blob storage object metadata](https://app.exampro.co/student/material/az-204/4245)
- [Transfer data between blobs within a storage account](https://app.exampro.co/student/material/az-204/4244)

Here is an old code sample [.NET Framework Blob Storage getting started source code](https://github.com/Azure-Samples/storage-blob-dotnet-getting-started). You may not use the full project bu there certainly is a lot you can use from here such as code examples etc.