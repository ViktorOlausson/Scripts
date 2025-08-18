#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'

$stageKeyPath = "HKLM:\SOFTWARE\WSLOrchestratorDemo"
$stageName = "stage"
$scriptPath = $PSCommandPath
$distro = "Ubuntu"

function GetStage {
    try {
        (Get-ItemProperty -Path $stageKeyPath -Name $stageName -ErrorAction Stop).$stageName
    }
    catch {
        0
    }
}

function Set-Stage([int]$n) {
    if(-not (Test-Path $stageKeyPath)){
        New-Item -Path $stageKeyPath -Force | Out-Null
    }
    New-ItemProperty -Path $stageKeyPath -Name $stageName -Value $n -PropertyType DWord -Force | Out-Null
}

function register-RunOnceSelf {
    $cmd = "powershell.exe -ExecutionPolicy Bypass -File `"$scriptPath`""
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "WSL-Orchestrator" -Value $cmd
}

function reboot-Now {
    Write-Host "Rebooting to finish installation and will resume automatically..."
    Restart-Computer -Force
}

function Test-UbuntuPresent {
    $list = & wsl -l -q 2>$null
    return ($list | Where-Object { $_ -eq $Distro }) -ne $null
}

function Test-WSLUsable{
    try {
        & wsl -d $Distro -- echo READY | Out-Null
        return $true
    } catch { return $false }
}

switch ($stage) {
    0 {
        try { wsl --set-default-version 2 | Out-Null } catch {}
        if (-not (Test-UbuntuPresent)) {
            Write-Host "Ubuntu not found. Installing..." -ForegroundColor Cyan
            wsl --install -d $Distro
            Set-Stage 1
            Register-RunOnceSelf
            reboot-Now
            return
        }
        Set-Stage 1
        $stage = 1
    }
    1{
        if (-not (Test-WSLUsable)) {
            Write-Host "Ubuntu is installed but not ready for non-interactive commands yet." -ForegroundColor Yellow
            Write-Host "Triggering a quick distro start and resuming after reboot..." -ForegroundColor Yellow
            Register-RunOnceSelf
            Reboot-Now
            return
        }
                Write-Host "Enabling systemd in Ubuntu..." -ForegroundColor Cyan
        wsl -d $Distro -- bash -lc "set -e
sudo mkdir -p /etc
if [ -f /etc/wsl.conf ]; then
  sudo awk 'BEGIN{seen=0} /^\[boot\]/{seen=1} {print} END{if(seen==0)print \"[boot]\nsystemd=true\"}' /etc/wsl.conf | sudo tee /etc/wsl.conf >/dev/null
else
  printf \"[boot]\nsystemd=true\n\" | sudo tee /etc/wsl.conf >/dev/null
fi
"

        wsl --shutdown

        Write-Host "Installing Docker Engine in Ubuntu..." -ForegroundColor Cyan
        wsl -d $Distro -- bash -lc "set -e
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \$(. /etc/os-release; echo \$VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl restart docker
# Add default user to docker group if not root
U=\$(id -un); if [ \"\$U\" != \"root\" ]; then sudo usermod -aG docker \"\$U\" || true; fi
"
        Write-Host "`nDone. Docker Engine is ready inside $Distro (WSL2)." -ForegroundColor DarkGreen
        Write-Host "Open '$Distro' and run:  docker version  |  docker pull yourorg/your-image:tag" -ForegroundColor DarkGreen
    }
    2 {
        Write-Host "Nothing to do. Docker Engine already set up inside $Distro." -ForegroundColor DarkGreen
    }
    #Default {}
}

try {
    wsl --version | Out-Null
}
catch {
    Write-Error "WSL is not available yet. Run your WSL-enabling script and reboot first."
    exit 1
}
wsl --set-default-version 2 | Out-Null

$distros = & wsl -l -q 2>$null
if(-not ($distros | Where-Object {$_ -match '^Ubuntu'})){
    Write-Host "Installing Ubuntu..." -ForegroundColor Cyan

    wsl --install -d Ubuntu
    Write-Host "if this was the first time install WSL features/distro, a reboot may be needed" -ForegroundColor Yellow
    Write-Host "after any reboot, re-run this script to finish installing docker"
    exit 0
}

