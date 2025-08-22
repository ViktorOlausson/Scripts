#if docker image already exists, dont pull
##add reusablity

try {
    Write-Host "Pulling docker image..." -ForegroundColor Yellow
    docker pull "viktorolausson/texteditorinc" > $null 2>&1
    if($LASTEXITCODE -eq 0){
        Write-Host "Pulled docker image" -ForegroundColor Green
    }else{
        Write-Host "Failed to pull docker image" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "Failed to pull docker image" -ForegroundColor Red
    exit 1
}