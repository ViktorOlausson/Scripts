function Run-Script {
    param ([string]$Name)
    $targetScript = Join-Path $PSScriptRoot "..\..\$Name.ps1"
    
    $targetScript = Resolve-Path $targetScript

    & $targetScript
    if ($LASTEXITCODE -notin @(0, 3010, -1978335135, -1978335189)) {
        exit 1
    }
}

Run-Script checkIsAdmin

Run-Script EnableWSLVMP

Run-Script checkDocker

Run-Script pullDocker ##add Docker image param

#ask for file path
#if it is a folder, ask for a file name to be created and then use that file
#if it is an file use the parent folder as path and use the file to launch