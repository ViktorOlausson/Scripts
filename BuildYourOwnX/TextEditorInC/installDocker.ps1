$ErrorActionPreference = 'Stop'

$osArch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
$channel = if ($osArch -eq 'Arm64') { 'arm64' } else { 'amd64' }

$downloadUrl = "https://desktop.docker.com/win/main/$channel/Docker%20Desktop%20Installer.exe"

$installer = Join-Path $env:TEMP "DockerDesktopInstaller-$channel.exe"

Write-Host "Detected OS architecture: $osArch"
Write-Host "Downloading: $downloadUrl"

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installer
    try {
        Start-Process -FilePath $installer -ArgumentList $arguments -Wait
        if($LASTEXITCODE -eq 0){
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
        Write-Host "Unable to install docker" -ForegroundColor Red
        Exit 1
    } 
}
catch {
    Write-Host "Unable to download docker installer" -ForegroundColor Red
    Exit 1
}