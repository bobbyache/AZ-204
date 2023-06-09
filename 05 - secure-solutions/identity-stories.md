# System Assigned Identity

Once upon a time in the Azure realm, there was a virtual machine eager to gain a special identity. It made a humble request to Azure Resource Manager, asking to be bestowed with a system-assigned managed identity.

Azure Resource Manager, the benevolent ruler, heard the plea and decided to grant the virtual machine its desired identity. With great power comes responsibility, so Azure Resource Manager created a service principal in Azure Active Directory specifically for the virtual machine. This service principal found its home in the trusted Azure Active Directory tenant of the subscription.

With the service principal in place, Azure Resource Manager took the next step in the process. It diligently configured the virtual machine's identity by updating the **Azure Instance Metadata Service** identity endpoint. This update included the crucial information of the service principal's client ID and certificate, ensuring a solid foundation for the virtual machine's identity.

Now that the virtual machine possessed its shiny new identity, it was time to embrace the world of Azure resources. Through the service principal, the virtual machine was granted access to these resources. Azure Resource Manager employed the wonders of role-based access control in Azure Active Directory, assigning the appropriate role to the virtual machine's service principal. Furthermore, for interactions with Key Vault, specific secrets or keys were granted access to the virtual machine's code.

Equipped with its identity and permissions, the virtual machine embarked on its journey within the Azure realm. Within the confines of its own existence, the virtual machine sought a token to prove its authenticity. It reached out to the Azure Instance Metadata service endpoint, accessible only from within itself, and obtained a token by providing its client ID and certificate. Azure Active Directory, the guardian of tokens, graciously responded with a JSON Web Token (JWT) access token, validating the virtual machine's identity.

Now armed with the access token, the virtual machine ventured forth to interact with various services. Whenever it approached a service that supported Azure Active Directory authentication, the virtual machine presented its access token. This token served as a key to unlock the service's gates, allowing the virtual machine's code to be recognized and welcomed.

And so, the virtual machine's tale in the Azure realm unfolded, showcasing the remarkable journey of obtaining and utilizing its system-assigned managed identity.

# User Assigned Identity

Once upon a time in the realm of Azure, a request arrived at the doorstep of Azure Resource Manager. The request was simple yet important: to create a user-assigned managed identity. Eager to fulfill its duty, Azure Resource Manager sprung into action.

With its powers at hand, Azure Resource Manager delved into the depths of Azure Active Directory, crafting a service principal specifically for the user-assigned managed identity. The service principal took its place within the Azure Active Directory tenant, a trusted realm within the subscription.

As the journey progressed, Azure Resource Manager received another beckoning call, this time to bestow the user-assigned managed identity upon a virtual machine. In response, it embarked on a transformative process. The Azure Instance Metadata Service identity endpoint underwent a significant update, embracing the user-assigned managed identity service principal's client ID and certificate. The virtual machine now possessed a connection to its new identity.

But the tale did not end there. The user-assigned managed identity yearned for purpose and access to Azure's plentiful resources. And so, Azure Resource Manager revealed a secret path—a path paved by role-based access control in Azure Active Directory. With careful orchestration, the appropriate role was bestowed upon the service principal, allowing the user-assigned identity to call upon Azure Resource Manager with rightful authority. In addition, the realm of Key Vault granted permission for the code to access specific secrets or keys, completing the identity's journey.

Within the virtual machine, nestled in its secluded domain, the code stirred to life. Eager to interact with the vast Azure kingdom, it sought a token—a key to unlock the realm's treasures. The Azure Instance Metadata Service identity endpoint, accessible only from within the virtual machine, became the code's destination—its secret gateway.

With a solemn request, the code journeyed to Azure Active Directory, yearning for an access token. Armed with the client ID and certificate configured during the earlier steps, it humbly presented its case. Azure Active Directory, in its infinite wisdom, rewarded the code's efforts with a precious gift—a JSON Web Token (JWT) access token, the key to the Azure kingdom.

With the access token securely in its grasp, the code embarked on its final endeavor. It embarked on a call to a service that embraced Azure Active Directory authentication. The access token, a testament to the code's identity, was presented with confidence and purpose, opening the doors to the awaiting service.

And thus, the story of the user-assigned managed identity unfolded—a tale of creation, empowerment, and authentication within the realm of Azure, where requests were answered, identities were granted, and the code found its rightful place among the azure skies.

# User Assigned Identity (Lord of the Rings)

In the vast realm of Azure, where clouds roamed and data flowed like ancient rivers, a request reached the ears of Azure Resource Manager, akin to a whisper carried by the wind. The task at hand was a quest of great importance—to forge a user-assigned managed identity, a hidden gem among the Azure treasures.

With the wisdom bestowed upon it, Azure Resource Manager took up its digital hammer and anvil, fashioning a service principal that would serve as the guardian of the user-assigned managed identity. The service principal, much like a mythical being, was breathed into existence within the hallowed halls of Azure Active Directory, in the trusted realm of the subscription.

But the journey did not end with the birth of the service principal. Another call, echoing through the virtual landscapes, beckoned Azure Resource Manager to undertake a perilous endeavor. It commanded the enigmatic entity to unveil the user-assigned managed identity upon a virtual machine, to empower it with purpose and capabilities.

Embracing the challenge, Azure Resource Manager ventured forth. It ventured deep into the heart of the Azure Instance Metadata Service, a realm accessible only by those who dwelled within the virtual machine. There, it performed a mystical rite, inscribing the sacred scrolls with the secrets of the user-assigned managed identity.

Once completed, the virtual machine became a vessel of power, bearing the mark of the user-assigned managed identity. Its veins pulsed with the essence of the service principal's client ID and the sigil of its certificate. The virtual machine stood tall, a sentinel with newfound identity.

Yet, the identity longed for purpose, to partake in the grand tapestry of Azure's riches. Azure Resource Manager, like a sage of old, revealed the path to unlock the kingdom's treasures. It unveiled the secrets of role-based access control within the Azure Active Directory, a realm where roles were bestowed upon the worthy.

The service principal, now blessed with a rightful role, earned the authority to call upon Azure Resource Manager, traversing its vast landscapes with confidence. Furthermore, Azure's Key Vault, a sanctum of secrets, allowed the code to access specific enigmas within its guarded chambers. The user-assigned managed identity was now armed with the blessings of Azure's realms.

Deep within the confines of the virtual machine, where the shadows whispered and the embers glowed, the code stirred with anticipation. Like a curious hobbit, it yearned for a token—a key that would grant it passage through the Azure kingdom's gates. The Azure Instance Metadata Service identity endpoint, akin to a hidden door accessible only within the virtual realm, held the promise of such a token.

With resolve in its heart, the code embarked on a perilous journey. It traversed the treacherous paths, bypassing firewalls and evading the watchful eyes of guardians. Finally, it arrived at the hallowed halls of Azure Active Directory, a domain as ancient as the elven realms of Middle-earth.

There, the code beseeched Azure Active Directory for an access token, using the very essence of the service principal—the client ID and certificate—as its bargaining chip. The Azure Active Directory, like a wise elf-king, acknowledged the code's worthiness and rewarded its quest with a coveted prize—an access token, akin to a golden ring of power, forged as a JSON Web Token (JWT).

With the access token clutched tightly, the code returned to the virtual machine, where its true purpose awaited. It set forth on its final task, calling upon a service that embraced the ways of Azure Active Directory. The access token, a symbol of the code's identity and rightful place, was presented with confidence and resolve, unlocking the doors to the awaiting service, where its destiny would be fulfilled.

And thus, the