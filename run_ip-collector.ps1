$ErrorActionPreference = "Stop"

Write-Host "IP Collector - One-Click Runner" -ForegroundColor Cyan

$baseUrl = $env:IP_COLLECTOR_RELEASE_URL
if (-not $baseUrl) {
    $baseUrl = "https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/windows"
}

$binaryName = "ip-collector.exe"
$runId = [DateTime]::Now.ToString("yyyyMMdd-HHmmss")
$tempDir = Join-Path $env:TEMP "ip-collector-$runId"
$binaryPath = Join-Path $tempDir $binaryName

Write-Host "Creating temp directory..."
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

Write-Host "Downloading $binaryName from $baseUrl..."
$maxRetries = 3
$ok = $false
for ($i = 1; $i -le $maxRetries; $i++) {
    try {
        Invoke-WebRequest -Uri "$baseUrl/$binaryName" -OutFile $binaryPath -UseBasicParsing
        $ok = $true
        break
    } catch {
        Write-Host "Download attempt $i/$maxRetries failed: $_" -ForegroundColor Yellow
        Start-Sleep -Seconds 1
    }
}
if (-not $ok) {
    Write-Host "Download failed after $maxRetries attempts." -ForegroundColor Red
    exit 1
}

Write-Host "Starting IP Collector..." -ForegroundColor Green
Set-Location $tempDir
& $binaryPath @args
