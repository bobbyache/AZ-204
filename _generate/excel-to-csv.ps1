param (
    [string]$ExcelFilePath,
    [string]$TSVFilePath,
    [string]$Delimiter = "`t"
)

# Check if the ImportExcel module is installed
if (-not (Get-Module -ListAvailable -Name "ImportExcel")) {
    # If not installed, install the ImportExcel module
    Write-Host "ImportExcel module not found. Installing..."
    Install-Module -Name "ImportExcel" -Scope CurrentUser -Force
}

# Load the ImportExcel module
Import-Module -Name "ImportExcel"

# Read the Excel file
$data = Import-Excel -Path $ExcelFilePath

# Export as TSV
$data | Export-Csv -Path $TSVFilePath -Delimiter $Delimiter -NoTypeInformation

Write-Host "Conversion complete. TSV file created."
