& Clear-Host

function Run {
    param ([string]$Name, [string]$arg)
    $targetScript = Join-Path $PSScriptRoot "..\..\$Name.ps1"
    $targetScript = Resolve-Path $targetScript

    if($arg -ne ""){
        & $targetScript $arg
    }
    else{
        & $targetScript
    }
    
    if ($LASTEXITCODE -notin @(0, 3010, -1978335135, -1978335189)) {
        exit 1
    }
}

$Image = "viktorolausson/nodejswebserver"
$Container = "VoNodeServer"

Run checkIsAdmin

Run EnableWSLVMP

Run checkDocker

Run pullDocker $Image

Run stopRemoveContainer $Container

& Clear-Host

& docker run -d -p 5000:5000 --name VoNodeServer viktorolausson/nodejswebserver:latest > $null 2>&1

Write-Host "Container is now running" -ForegroundColor Green
Write-Host "Standard address is: http://localhost:5000" -ForegroundColor Cyan