#Requires -RunAsAdministrator

function Enable-Feature {
    param ([string]$Name)
    $f = Get-WindowsOptionalFeature -Online -FeatureName $Name

    if($f.State -eq 'Enabled'){
        Write-Host "'$Name' already enabled" -ForegroundColor Green
    }else{
        try {
            Write-Host "Enabling '$Name" -ForegroundColor Yellow
            $output = & dism.exe /online /enabled-feature /featurename:$name /all /norestart 2>&1
            if($LASTEXITCODE -eq 0){
                Write-Host "'$Name' has been enabled" -ForegroundColor Green
            }else {
                Write-Host "Failed to enable '$Name' (Exit code $LASTEXITCODE)" -ForegroundColor Red
                Write-Host ($output | Select-Object -Last 5) -ForegroundColor Red
                Exit 1
            }
        }
        catch {
            Write-Host "error" -ForegroundColor Red
            Exit 1
        }
    }
}

Enable-Feature Microsoft-Windows-Subsystem-Linux
Enable-Feature VirtualMachinePlatform
try {
    Write-Host "Setting WSL to version 2" -ForegroundColor Yellow
    $setWsl = & wsl --set-default-version 2 *> $null
    if($LASTEXITCODE -eq 0){
        Write-Host "WSL version has been set to version 2" -ForegroundColor Green
    }else{
        Write-Host "Unable to set WSL to version 2 (exit code $LASTEXITCODE)." -ForegroundColor Red
        Write-Host ($setWsl | Select-Object -Last 5) -ForegroundColor Red
        exit 1
    }   
}
catch {
    Write-Host "Failed to set WSL default version: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
$pending = Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue
if ($pending) {
    Write-Host "WSL2 prerequisites ensured." -ForegroundColor Green
    Write-Host "System restart is required. Restart and run this script again" -ForegroundColor Yellow
    exit 1
}else{
    Write-Host "WSL2 prerequisites ensured." -ForegroundColor Green
    Write-Host "No restart needed" -ForegroundColor Green
    exit 0
}