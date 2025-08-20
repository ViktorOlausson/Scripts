try{
    $docker = docker --version 2>$null
    if($LASTEXITCODE -eq 0){
        Write-Output "Docker Engine is installed" #no output if installed?
    }else {
        Write-Output "Docekr Engine is NOT installed, please install Docker to run this command"
        exit 1
    }
}catch{
    Write-Output "Docekr Engine is NOT installed, please install Docker to run this command"
}

try{
    $dockerHub = docker login --help 2>$null
    if($LASTEXITCODE -eq 0){
        Write-Output "Docker Hub CLI is installed"
    }else{
        Write-Output "Docker Hub CLI is NOT installed, please install Docker to run this command"
    }
}catch{
    Write-Output "Docker Hub CLI is NOT available, please install Docker to run this command"
}

try{
    docker info >$null 2>&1
    if($LASTEXITCODE -eq 0){
        Write-Output "Docker daemon is running"
    }else{
        Write-Output "Docker daemon is not running, please start docker and rerun this script"
        exit 1
    }
}catch{
    Write-Output "Docker daemon is not running"
}