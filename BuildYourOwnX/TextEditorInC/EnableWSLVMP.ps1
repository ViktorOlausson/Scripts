#Requires -RunAsAdministrator

function Enable-Feature {
    param ([string]$Name)
    $f = Get-WindowsOptionalFeature -Online -FeatureName $Name

    if($f.State -eq 'Enabled'){
        Write-Host "'$Name' already enabled" -ForegroundColor Green
    }else{
        try {
            Write-Host "Enabling '$Name" -ForegroundColor Yellow
            dism.exe /online /enabled-feature /featurename:$name /all /norestart *> $null
            if($LASTEXITCODE -eq 0){
                Write-Host "'$Name' has been enabled" -ForegroundColor Green
            }else {
                Write-Host "Something went wrong" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "error" -ForegroundColor Red
        }
    }
}

Enable-Feature Microsoft-Windows-Subsystem-Linux
Enable-Feature VirtualMachinePlatform

wsl --set-default-version 2 *> $null

Write-Host "WSL2 prerequisites ensured. If features were just enabled, a reboot may be required." -ForegroundColor Green