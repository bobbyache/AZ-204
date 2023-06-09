$resourceGroup = "resourcegroupo"
$location = "eastus"
$redisCacheName = "rediscachebasic"
$sku = "Basic"
$vmSize = "c0"
$capacity = 1

# Check if you're logged in to Azure
if (-not (Get-AzContext)) {
    # If you're not logged in, perform Az login
    Connect-AzAccount
}
else {
    # If you're logged in, display a message
    $userName = (Get-AzContext).Account.Id
    Write-Output "You're already logged in to Azure as $userName."
}

New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Redis cache (capacity in Gigabytes)
New-AzRedisCache -ResourceGroupName $resourceGroup -Name $redisCacheName -Location $location -Sku $sku -Size $vmSize

# Get Redis cache primary key
$redisCache = Get-AzRedisCache -ResourceGroupName $resourceGroup -Name $redisCacheName
$connectionString = $redisCache.RedisConfiguration.PrimaryKey

Write-Output "Azure Cache for Redis resource created successfully."
Write-Output "Connection string: $connectionString"
