param(
    [string]$Image = ""
)

docker image inspect $image *> $null

if($LASTEXITCODE -ne 0){
    Write-Host "Docker image not found exists, pulling latest image" -ForegroundColor Yellow
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
}else{
    Write-Host "Image already exists" -ForegroundColor Green
    exit 0
}