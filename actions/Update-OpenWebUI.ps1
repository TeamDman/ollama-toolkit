Write-Host "Checking IPv6 status"
$ipv6_enabled = Get-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6 | Select-Object -ExpandProperty Enabled
$restore_ipv6 = $false
if ($ipv6_enabled -eq "True") {
    Write-Host "IPv6 is enabled, this can slow down Docker pull from ghcr.io significantly. Turning it off for now."
    Disable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6
    if ($?) {
        $restore_ipv6 = $true
    }
} else {
    Write-Host "IPv6 is disabled, good"
}

Write-Host "Pulling latest image"
docker pull ghcr.io/open-webui/open-webui:main

if ($restore_ipv6) {
    Write-Host "Re-enabling IPv6"
    Enable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6
}

Write-Host "Stopping old containers"
$webui_images = docker images --format "{{json .}}" `
| ConvertFrom-Json `
| Where-Object { $_.Repository -eq "ghcr.io/open-webui/open-webui" } `
| Select-Object -ExpandProperty ID
$webui_images += @("ghcr.io/open-webui/open-webui:main")
$webui_containers = docker ps --all --format "{{json .}}" `
| ConvertFrom-Json `
| Where-Object { $_.Image -in $webui_images }
foreach ($container in $webui_containers) {
    Write-Host "Stopping container $($container.Names)"
    docker stop $container.ID
}

Write-Host "Starting container"
$date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$container_id = docker run -d -p 8069:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name "open-webui-$date" --restart always ghcr.io/open-webui/open-webui:main

while ($true) {
    Write-Host "Checking for readyness"
    $logs = docker logs $container_id 2>&1
    if ($logs -match "Application startup complete.") {
        break
    }
    Start-Sleep -Seconds 1
}

Write-Host "You can access the web interface at http://localhost:8069"