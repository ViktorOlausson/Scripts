function Run {
    param ([string]$Name, [string]$DockerImage)
    $targetScript = Join-Path $PSScriptRoot "..\..\$Name.ps1"
    $targetScript = Resolve-Path $targetScript

    if($DockerImage -ne ""){
        & $targetScript -Image $DockerImage
    }
    else{
        & $targetScript
    }
    
    if ($LASTEXITCODE -notin @(0, 3010, -1978335135, -1978335189)) {
        exit 1
    }
}

Run checkIsAdmin

Run EnableWSLVMP

Run checkDocker

Run pullDocker "viktorolausson/texteditorinc"

#ask for file path
#if it is a folder, ask for a file name to be created and then use that file
#if it is an file use the parent folder as path and use the file to launch

& Clear-Host

Write-Host "Choose a texted based file to edit" -ForegroundColor Cyan

Add-Type -AssemblyName System.Windows.Forms
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")   # default folder
$dialog.Filter = "All files (*.*)|*.*"                               # filter

if ($dialog.ShowDialog() -eq "OK") {
    $blockedExtensions = ".exe", ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".mp4", ".avi", ".mov", ".mkv", ".mp3", ".wav"
    $filePath = $dialog.FileName
    $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
    if ($blockedExtensions -contains $ext) {
        Write-Host "This file type is not allowed ($ext)." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "You chose: $filePath"
    }
} else {
    Write-Host "No file selected, stopping script" -ForegroundColor Red
    exit 1
}