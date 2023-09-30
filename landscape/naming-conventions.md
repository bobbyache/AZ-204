# Naming Conventions

## Storage

### Cosmos DB Account
- Must be between 3 and 44 characters long
- Contain only lowercase letters and numbers and '-'
- Cannot contain consecutive hyphens.
- Must not start or end with '-'

### Azure Storage Account
- Must be between 3 and 24 characters long
- Contain only lowercase letters and numbers

### Queue Storage
- Must be between 3 and 63 characters long
- Contain only lowercase letters and numbers and '-'
- Cannot contain consecutive hyphens.
- Must not start or end with '-'

### Containers
- Must be between 3 and 63 characters long
- Contain only lowercase letters and numbers and '-'
- Cannot contain consecutive hyphens
- Must not start with '-'
- Must not end with '-'

### Table Storage
- Must be between 3 and 63 characters long
- Contain only lowercase letters and numbers and
- Cannot not contain hyphens.

### File shares
- Must be at least 3 characters long
- Contain only lowercase letters and numbers and '-'
- Cannot contain consecutive hyphens
- Must not start or end with '-'

# Caching

### Azure Content Delivery Network
- Contain letters and numbers and '-'
- Must not start or end with '-'
- Must not end with '-'

### Azure Cache for Redis
- Must be globally unique (public facing URL)
- Must be between 1 and 63 characters long
- Contain only lowercase letters and numbers and '-'
- Cannot contain consecutive hyphens
- Must not start or end with '-'

# Containerization

### Container Registry
- Must be between 5 and 50 characters long
- Contain letters and numbers

### Container Instance
- Must be between 1 and 63 characters long
- Unique in current resource group
- Contain only lowercase letters and numbers and '-'
- Cannot contain consecutive hyphens
- Must not start or end with '-'

### Container Apps
- Must be between 1 and 32 characters long
- Contain only lowercase letters and numbers and '-'
- Cannot contain consecutive hyphens
- Must not start or end with '-'


# Monitoring

### Application Insights
- Must be between 1 and 255 characters long
- Contain only alphanumeric characters, periods, underscores, hyphens, and parenthesis.
- Must not end with a period
- Valid example: `application.insights-23445_(23)` and `.application.insights--23445_(23)-`.

# Solutions

### Web Apps
- Must be between 3 and 63 characters long
- Contain alphanumeric characters and '-'
- Cannot contain consecutive hyphens
- Must not start or end with '-'

### Function Apps
- Must be between 2 and 63 characters long
- Contain only alphanumeric characters and '-'
- Must not start or end with '-'

### Key Vault
- Must be between 3 and 24 characters long
- Contain alphanumeric characters and '-'
- Cannot contain consecutive hyphens
- Must not start or end with '-'

### API Management
- Must be between 2 and 50 characters long
- Contain alphanumeric characters and '-'
- Must not start or end with '-'

# Queues and Messaging

### Service Bus
- Must be between 6 and 50 characters long
- Contain alphanumeric characters and '-'
- Cannot contain consecutive hyphens
- Must not start or end with '-'

### Event Hubs
- Name becomes DNS namespace must be unique throughout Azure
- Must be between 6 and 50 characters long
- Contain alphanumeric characters and '-'
- Cannot contain consecutive hyphens
- Must not start or end with '-'

### Event Grid Topic
- Must be between 3 and 50 characters long
- Contain alphanumeric characters and '-'

