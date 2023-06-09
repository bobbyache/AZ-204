$myKeyVault = "az204vault-$([System.Guid]::NewGuid().ToString())"
$myLocation = "<myLocation>"

New-AzResourceGroup -Name "az204-vault-rg" -Location $myLocation

New-AzKeyVault -VaultName $myKeyVault -ResourceGroupName "az204-vault-rg" -Location $myLocation

New-AzKeyVault -VaultName $myKeyVault -ResourceGroupName "az204-vault-rg" -Location $myLocation

Set-AzKeyVaultSecret -VaultName $myKeyVault -Name "ExamplePassword" -SecretValue "hVFkk965BuUv"

Get-AzKeyVaultSecret -VaultName $myKeyVault -Name "ExamplePassword"

Remove-AzResourceGroup -Name "az204-vault-rg" -Force -AsJob
