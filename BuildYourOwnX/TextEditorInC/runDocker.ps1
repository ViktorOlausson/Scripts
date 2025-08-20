try{
    Write-Host "Checking if Docker Desktop is installed..." -ForegroundColor Yellow
    $dockerHub = docker login --help 2>$null
    if($LASTEXITCODE -eq 0){
        Write-Host "Docker Hub CLI is installed" -ForegroundColor Green
    }else{
        Write-Host "Docker Hub CLI is NOT installed, please install Docker to run this command" -ForegroundColor Red
    }
}catch{
    Write-Host "Docker Hub CLI is NOT available, please install Docker to run this command" -ForegroundColor Red
}

try{
    Write-Host "Checking if Docker engine is installed..." -ForegroundColor Yellow
    $docker = docker --version 2>$null
    if($LASTEXITCODE -eq 0){
        Write-Host "Docker Engine is installed" -ForegroundColor Green #no output if installed?
    }else {
        Write-Host "Docekr Engine is NOT installed, please install Docker to run this command" -ForegroundColor Red
        exit 1
    }
}catch{
    Write-Host "Docekr Engine is NOT installed, please install Docker to run this command" -ForegroundColor Red
    exit 1
}

try{
    Write-Host "Checking if Docker is running..." -ForegroundColor Yellow
    docker info >$null 2>&1
    if($LASTEXITCODE -eq 0){
        Write-Host "Docker daemon is running" -ForegroundColor Green
    }else{
        Write-Host "Docker daemon is not running, please start docker and rerun this script" -ForegroundColor Red
        exit 1
    }
}catch{
    Write-Host "Docker daemon is not running" -ForegroundColor Red
    exit 1
}

#if docker image already exists, dont

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

#ask for file path
#if it is a folder, ask for a file name to be created and then use that file
#if it is an file use the parent folder as path and use the file to launch