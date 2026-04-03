$ErrorActionPreference = "Stop"

Write-Host "IP Collector - One-Click Runner" -ForegroundColor Cyan

$explicitBaseUrl = $env:IP_COLLECTOR_RELEASE_URL
$defaultRawBaseUrl = "https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/windows"
$defaultGhProxyOrgBaseUrl = "https://gh-proxy.org/https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/windows"
$defaultCdnGhProxyBaseUrl = "https://cdn.gh-proxy.org/https://github.com/laohuyou886/ip-deploy/raw/main/bin/windows"
$defaultHkGhProxyBaseUrl = "https://hk.gh-proxy.org/https://github.com/laohuyou886/ip-deploy/raw/main/bin/windows"
$defaultCdnBaseUrl = "https://cdn.jsdelivr.net/gh/laohuyou886/ip-deploy@main/bin/windows"
$defaultGhProxyBaseUrl = "https://ghproxy.com/$defaultRawBaseUrl"

$baseUrls = @()
if ($explicitBaseUrl) {
    $baseUrls += $explicitBaseUrl
} else {
    $useCdn = $env:IP_COLLECTOR_USE_CDN
    if (-not $useCdn) { $useCdn = "1" }
    $useCdn = $useCdn.Trim()
    $cdnOff = @("0","false","FALSE","no","NO") -contains $useCdn
    if ($cdnOff) {
        $baseUrls += $defaultGhProxyOrgBaseUrl, $defaultCdnGhProxyBaseUrl, $defaultHkGhProxyBaseUrl, $defaultRawBaseUrl, $defaultCdnBaseUrl, $defaultGhProxyBaseUrl
    } else {
        $baseUrls += $defaultGhProxyOrgBaseUrl, $defaultCdnGhProxyBaseUrl, $defaultHkGhProxyBaseUrl, $defaultCdnBaseUrl, $defaultRawBaseUrl, $defaultGhProxyBaseUrl
    }
}

$binaryName = "ip-collector.exe"
$runId = [DateTime]::Now.ToString("yyyyMMdd-HHmmss")
$tempDir = Join-Path $env:TEMP "ip-collector-$runId"
$binaryPath = Join-Path $tempDir $binaryName

Write-Host "Creating temp directory..."
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

Write-Host "Downloading $binaryName..."
$maxRetries = 3
$ok = $false
foreach ($baseUrl in $baseUrls) {
    Write-Host "  - Trying: $baseUrl/$binaryName"
    for ($i = 1; $i -le $maxRetries; $i++) {
        try {
            Invoke-WebRequest -Uri "$baseUrl/$binaryName" -OutFile $binaryPath -UseBasicParsing
            $ok = $true
            break
        } catch {
            Write-Host "    Download attempt $i/$maxRetries failed: $_" -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
    }
    if ($ok) { break }
}
if (-not $ok) {
    Write-Host "Download failed after $maxRetries attempts." -ForegroundColor Red
    exit 1
}

Write-Host "Starting IP Collector..." -ForegroundColor Green
Set-Location $tempDir
& $binaryPath @args
