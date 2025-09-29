& Clear-Host

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

$Image = "viktorolausson/texteditorinc"

Run checkIsAdmin

Run EnableWSLVMP

Run checkDocker

Run pullDocker $Image

& Clear-Host

Write-Host "Choose a texted based file to edit" -ForegroundColor Cyan

Add-Type -AssemblyName System.Windows.Forms
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
$dialog.Filter = "All files (*.*)|*.*"

if ($dialog.ShowDialog() -eq "OK") {
    $blockedExtensions = ".exe", ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".mp4", ".avi", ".mov", ".mkv", ".mp3", ".wav", ".jar"
    $filePath = $dialog.FileName
    $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
    if ($blockedExtensions -contains $ext) {
        Write-Host "This file type is not allowed ($ext)." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "You chose: $filePath"
    }
    $folderPath = [System.IO.Path]::GetDirectoryName($filePath)
    $fileName   = [System.IO.Path]::GetFileName($filePath)
} else {
    Write-Host "No file selected, stopping script" -ForegroundColor Red
    exit 1
}

& docker run --rm -it --mount type=bind,source=$folderPath,target=/data/ $Image /data/$fileName