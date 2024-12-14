while ($true) {
    $x = nvidia-smi --query-gpu=memory.total,memory.used,memory.free --format=csv
    Clear-Host
    $x | Write-Host
    Start-Sleep -Seconds 1
}
