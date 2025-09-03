param(
    [string]$Container = ""
)

try {
    Write-Host "Stopping and Removing existing containers for this image" -ForegroundColor Yellow
    #check if container exists

    #if it exists check if it is running

    #if both true: stop container and then remove it

    #if container not running: remove the container

    #if neither: do nothing
}
catch {
    <#Do this if a terminating exception happens#>
}