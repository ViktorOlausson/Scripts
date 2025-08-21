#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'

Write-Host "Downloading docker" -ForegroundColor Cyan

try {
    winget install --id Docker.DockerDesktop -e --silent --accept-source-agreements --accept-package-agreements

    if ($LASTEXITCODE -in 0, 3010, -1978335135, -1978335189) {
        if ($exitCode -eq 3010) {
            Write-Host "Docker Desktop installed/updated, but a restart is needed." -ForegroundColor Yellow
            Write-Host "Restart the system, then run this script again."
            exit 1
        }
        Write-Host "Docker Desktop is installed. Version info:" -ForegroundColor Green
        try { docker --version } catch { Write-Warning "docker CLI not yet on PATH; sign out/in or reboot may be needed." }
    }
    else {
        Write-Host "winget failed with exit code $exitCode" -ForegroundColor Red
        Write-Host "Please try to install Docker manually and try again." -ForegroundColor Yellow
        exit $exitCode
    }
}
catch {
    Write-Host "Unable to install Docker Desktop: $_" -ForegroundColor Red
    Write-Host "Please try and install docker manually and try again" -ForegroundColor Yellow
    Exit 1
}