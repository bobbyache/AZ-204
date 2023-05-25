param (
    [string]$FolderPath,
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

# Get all Excel files in the specified folder
$excelFiles = Get-ChildItem -Path $FolderPath -Filter "*.xlsx"

foreach ($excelFile in $excelFiles) {
    # Read the Excel file
    $data = Import-Excel -Path $excelFile

    # Export as TSV
    # $data | Export-Csv -Path $TSVFilePath -Delimiter $Delimiter -NoTypeInformation

    # Create the corresponding TSV file path
    $tsvFile = $excelFile.FullName -replace '\.xlsx$', '.tsv'

    # # Read the Excel file
    # $data = Import-Excel -Path $excelFile.FullName

    # Export as TSV
    $data | Export-Csv -Path $tsvFile -Delimiter $Delimiter -NoTypeInformation
    Write-Host "Conversion complete. TSV file created: $tsvFile"
}
