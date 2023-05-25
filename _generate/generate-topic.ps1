param (
    [string]$Module,
    [string]$Topic
)

# Create module and topic folder names in lower case
$ModuleFolder = $Module.ToLower().Replace(" ", "-")
$TopicFolder = $Topic.ToLower().Replace(" ", "-")

# Construct the full paths for module and topic folders
$ModuleFolderPath = Join-Path -Path $PWD -ChildPath $ModuleFolder
$TopicFolderPath = Join-Path -Path $ModuleFolderPath -ChildPath $TopicFolder

# Check if the module folder exists, and create it if necessary
if (-not (Test-Path -Path $ModuleFolderPath -PathType Container)) {
    New-Item -Path $ModuleFolderPath -ItemType Directory | Out-Null
    Write-Host "Created module folder: $ModuleFolder"
}

# Check if the topic folder exists, and prompt to overwrite if necessary
if (Test-Path -Path $TopicFolderPath -PathType Container) {
    $confirmationMessage = "Are you sure you want to overwrite the existing structure? (Y/N)"
    $overwrite = Read-Host -Prompt $confirmationMessage
    if ($overwrite -ne "Y") {
        Write-Host "Operation aborted."
        return
    }
}
else {
    New-Item -Path $TopicFolderPath -ItemType Directory | Out-Null
    Write-Host "Created topic folder: $TopicFolder"
}

# Create the files inside the topic folder
$EasyFlashcardsFileName = Join-Path -Path $TopicFolderPath -ChildPath "${TopicFolder}-easy-flashcards.txt"
$HardFlashcardsFileName = Join-Path -Path $TopicFolderPath -ChildPath "${TopicFolder}-hard-flashcards.txt"
$PlantUMLFileName = Join-Path -Path $TopicFolderPath -ChildPath "${TopicFolder}-mindmap.plantuml"
$MarkdownFileName = Join-Path -Path $TopicFolderPath -ChildPath "${TopicFolder}-summary.md"

# Create or prompt to overwrite the text file
if (Test-Path -Path $EasyFlashcardsFileName -PathType Leaf) {
    $confirmationMessage = "The text file already exists. Do you want to overwrite it? (Y/N)"
    $overwrite = Read-Host -Prompt $confirmationMessage
    if ($overwrite -ne "Y") {
        Write-Host "Skipping text file creation."
    }
    else {
        $null = New-Item -Path $EasyFlashcardsFileName -ItemType File
        Write-Host "Created text file: $EasyFlashcardsFileName"
    }
}
else {
    $null = New-Item -Path $EasyFlashcardsFileName -ItemType File
    Write-Host "Created text file: $EasyFlashcardsFileName"
}

# Create or prompt to overwrite the text file
if (Test-Path -Path $HardFlashcardsFileName -PathType Leaf) {
    $confirmationMessage = "The text file already exists. Do you want to overwrite it? (Y/N)"
    $overwrite = Read-Host -Prompt $confirmationMessage
    if ($overwrite -ne "Y") {
        Write-Host "Skipping text file creation."
    }
    else {
        $null = New-Item -Path $HardFlashcardsFileName -ItemType File
        Write-Host "Created text file: $HardFlashcardsFileName"
    }
}
else {
    $null = New-Item -Path $HardFlashcardsFileName -ItemType File
    Write-Host "Created text file: $HardFlashcardsFileName"
}

# Create or prompt to overwrite the PlantUML file
if (Test-Path -Path $PlantUMLFileName -PathType Leaf) {
    $confirmationMessage = "The PlantUML file already exists. Do you want to overwrite it? (Y/N)"
    $overwrite = Read-Host -Prompt $confirmationMessage
    if ($overwrite -ne "Y") {
        Write-Host "Skipping PlantUML file creation."
    }
    else {
        $null = New-Item -Path $PlantUMLFileName -ItemType File
        Write-Host "Created PlantUML file: $PlantUMLFileName"
    }
}
else {
    $null = New-Item -Path $PlantUMLFileName -ItemType File
    Write-Host "Created PlantUML file: $PlantUMLFileName"
}

# Create or prompt to overwrite the Markdown file
if (Test-Path -Path $MarkdownFileName -PathType Leaf) {
    $confirmationMessage = "The Markdown file already exists. Do you want to overwrite it? (Y/N)"
    $overwrite = Read-Host -Prompt $confirmationMessage
    if ($overwrite -ne "Y") {
        Write-Host "Skipping Markdown file creation."
    }
    else {
        $null = New-Item -Path $MarkdownFileName -ItemType File
        Write-Host "Created Markdown file: $MarkdownFileName"
    }
}
else {
    $null = New-Item -Path $MarkdownFileName -ItemType File
    Write-Host "Created Markdown file: $MarkdownFileName"
}
