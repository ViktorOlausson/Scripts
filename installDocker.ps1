#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'

Write-Host "Downloading docker" -ForegroundColor Cyan

try {
    winget install --id Docker.DockerDesktop -e --silent --accept-source-agreements --accept-package-agreements
    try {
        Start-Process -FilePath $installer -ArgumentList $arguments -Wait
        if($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 3010){
            $pendingRestart = Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue
            if($pendingRestart){
                Write-Host "Docker Desktop installed. But restart is needed" -ForegroundColor Yellow
                Write-Host "Restart system then run this script again"
                Exit 1
            }else{
                Write-Host "Docker Desktop installed. Version info:" -ForegroundColor Green
                try { docker --version } catch { Write-Warning "docker CLI not yet on PATH; sign out/in or reboot may be needed." }
            }
            
        }
    }
    catch {
        Write-Host "winget failed with exit code $exitCode" -ForegroundColor Red
        Write-Host "Please try and install docker manually and try again" -ForegroundColor Yellow
        Exit $exitCode
    } 
}
catch {
    Write-Host "Unable to install Docker Desktop: $_" -ForegroundColor Red
    Write-Host "Please try and install docker manually and try again" -ForegroundColor Yellow
    Exit 1
}