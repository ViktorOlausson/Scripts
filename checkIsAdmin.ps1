$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
Write-Host "Please run this script in an elevated PowerShell (Run as Administrator)." -ForegroundColor Red
}else {
    Write-Host "In admin" -ForegroundColor Green
}