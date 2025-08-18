#Requires -RunAsAdministrator

function Enable-Feature {
    param ([string]$Name)
    $f = Get-WindowsOptionalFeature -Online -FeatureName $Name
    if($f.State -ne 'Enabled'){
        dism.exe /online /enabled-feature /featurename:$name /all /norestart | Out-Null
    }
}

Enable-Feature Microsoft-Windows-Subsystem-Linux
Enable-Feature VirtualMachinePlatform

wsl --set-default-version 2

Write-Output "WSL2 prerequisites ensured. If features were just enabled, a reboot may be required."