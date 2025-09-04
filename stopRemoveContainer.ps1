param(
    [string]$Container = ""
)

try {
    Write-Host "Checking if docker container exists..." -ForegroundColor Cyan
    #check if container exists
    if(docker ps --filter "name=$container" --format "{{.Names}}"){
        Write-Host "Docker container exists and is running" -ForegroundColor Cyan
        Write-Host "Stopping and removing container..." -ForegroundColor Yellow
        & docker stop $Container  > $null 2>&1
        & docker rm $Container  > $null 2>&1
        if($LASTEXITCODE -eq 0){
            Write-Host "Stopped and removed docker container" -ForegroundColor Green
        }else{
            Write-Host "Failed to stop and remove docker container" -ForegroundColor Red
            exit 1
        }
    }elseif(docker ps -a --filter "name=$container" --format "{{.Names}}"){
        Write-Host "Docker container exists but is not running" -ForegroundColor Cyan
        Write-Host "Removing container..." -ForegroundColor Yellow
        & docker rm $Container  > $null 2>&1
        if($LASTEXITCODE -eq 0){
            Write-Host "Removed docker container" -ForegroundColor Green
        }else{
            Write-Host "Failed to remove docker container" -ForegroundColor Red
            exit 1
        }
    }else{
        Write-Host "Container does not exist" -ForegroundColor Green
    }
}
catch {
    Write-Host "Oops. Something went wrong: $_" -ForegroundColor Red
    Exit 1
}