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

#ask for file path
#if it is a folder, ask for a file name to be created and then use that file
#if it is an file use the parent folder as path and use the file to launch