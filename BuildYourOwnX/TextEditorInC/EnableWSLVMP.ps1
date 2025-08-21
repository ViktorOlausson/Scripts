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
                Write-Host ($output | Select-Object -Last 5) -ForegroundColor Red #does not work
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
    wsl --set-default-version 2 *> $null
}
catch {
    Write-Host "Failed to set WSL default version: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "WSL2 prerequisites ensured. If features were just enabled, a reboot may be required." -ForegroundColor Green