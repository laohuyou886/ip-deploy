@echo off
chcp 65001 >nul
echo IP Collector - One-Click Runner

if "%IP_COLLECTOR_RELEASE_URL%"=="" (
    set "BASE_URL=https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/windows"
) else (
    set "BASE_URL=%IP_COLLECTOR_RELEASE_URL%"
)

set BINARY_NAME=ip-collector.exe
set TEMP_DIR=%TEMP%\ip-collector-%RANDOM%
set BINARY_PATH=%TEMP_DIR%\%BINARY_NAME%

echo Creating temp directory...
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

echo Downloading %BINARY_NAME% from %BASE_URL%...
set RETRIES=3
set TRY=0
:download_retry
set /a TRY+=1
curl -fsSL -o "%BINARY_PATH%" "%BASE_URL%/%BINARY_NAME%"
if errorlevel 1 (
    echo Download attempt %TRY%/%RETRIES% failed
    if %TRY% LSS %RETRIES% (
        timeout /t 1 >nul
        goto :download_retry
    )
    echo Download failed after %RETRIES% attempts
    exit /b 1
)

echo Starting IP Collector...
cd /d "%TEMP_DIR%"
"%BINARY_PATH%" %*
