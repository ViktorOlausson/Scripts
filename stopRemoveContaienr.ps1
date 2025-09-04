param(
    [string]$Container = ""
)

try {
    Write-Host "Checking if docker container exists" -ForegroundColor Cyan
    #check if container exists
    if(docker ps --filter "name=$container" --format "{{.Names}}"){
        Write-Host "docker container exists and is running" -ForegroundColor Cyan
        Write-Host "Stopping and removing container" -ForegroundColor Yellow
    }elseif(docker ps -a --filter "name=$container" --format "{{.Names}}"){
        Write-Host "docker container exists but is not running" -ForegroundColor Cyan
        Write-Host "Removing container" -ForegroundColor Yellow
    }else{
        Write-Host "Container does not exist" -ForegroundColor Green
    }
}
catch {
    Write-Host "Oops. Something went wrong: $_" -ForegroundColor Red
    Exit 1
}