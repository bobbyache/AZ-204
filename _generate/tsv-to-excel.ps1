
param (
    [string]$FolderPath,
    [string]$SourceFileExtension = "*.txt",
    [string]$Delimiter = "`t",
    [int]$linesToRemove = 2
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
$textFiles = Get-ChildItem -Path $FolderPath -Filter $SourceFileExtension

foreach ($filePath in $textFiles) {
    # Remove the first x lines from the text file
    (Get-Content $filePath | Select-Object -Skip $linesToRemove) | Set-Content $filePath

    # Convert the tab-delimited text file to an Excel file
    $excelFilePath = $filePath -replace '\.txt$', '.xlsx'
    $excel = New-Object -ComObject Excel.Application
    $workbook = $excel.Workbooks.Open($filePath)
    $worksheet = $workbook.Worksheets.Item(1)
    $worksheet.SaveAs($excelFilePath, 51)  # Save as XLSX format
    $workbook.Close()
    $excel.Quit()

    Write-Host "Excel file saved at: $excelFilePath"
}

Write-Host "Conversion complete."
