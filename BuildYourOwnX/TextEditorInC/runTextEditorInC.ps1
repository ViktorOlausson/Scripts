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