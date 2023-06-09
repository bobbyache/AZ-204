$myApiName = "robaz-apim-$([guid]::NewGuid())"
$myLocation = "eastus"
$myEmail = "robbie.a.blake@gmail.com"

# Create a resource group
New-AzResourceGroup -Name "robazresourcegroup" -Location "eastus"

New-AzApiManagement -ResourceGroupName "robazresourcegroup" `
                   -Name $myApiName `
                   -Location $myLocation `
                   -PublisherEmail $myEmail `
                   -PublisherName "robaz-apim-publisher" `
                   -SkuName "Consumption"
