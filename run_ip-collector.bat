@echo off
setlocal EnableExtensions
chcp 65001 >nul
echo IP Collector - One-Click Runner

set "DEFAULT_RAW_BASE_URL=https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/windows"
set "DEFAULT_CDN_BASE_URL=https://cdn.jsdelivr.net/gh/laohuyou886/ip-deploy@main/bin/windows"
set "DEFAULT_GHPROXY_BASE_URL=https://ghproxy.com/https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/windows"

set "BASE_URL_LIST="
if "%IP_COLLECTOR_RELEASE_URL%"=="" (
    if "%IP_COLLECTOR_USE_CDN%"=="" set "IP_COLLECTOR_USE_CDN=1"
    if /I "%IP_COLLECTOR_USE_CDN%"=="0" (
        set "BASE_URL_LIST=%DEFAULT_RAW_BASE_URL% %DEFAULT_CDN_BASE_URL% %DEFAULT_GHPROXY_BASE_URL%"
    ) else if /I "%IP_COLLECTOR_USE_CDN%"=="false" (
        set "BASE_URL_LIST=%DEFAULT_RAW_BASE_URL% %DEFAULT_CDN_BASE_URL% %DEFAULT_GHPROXY_BASE_URL%"
    ) else if /I "%IP_COLLECTOR_USE_CDN%"=="no" (
        set "BASE_URL_LIST=%DEFAULT_RAW_BASE_URL% %DEFAULT_CDN_BASE_URL% %DEFAULT_GHPROXY_BASE_URL%"
    ) else (
        set "BASE_URL_LIST=%DEFAULT_CDN_BASE_URL% %DEFAULT_RAW_BASE_URL% %DEFAULT_GHPROXY_BASE_URL%"
    )
) else (
    set "BASE_URL_LIST=%IP_COLLECTOR_RELEASE_URL%"
)

set "BINARY_NAME=ip-collector.exe"
set "TEMP_DIR=%TEMP%\ip-collector-%RANDOM%"
set "BINARY_PATH=%TEMP_DIR%\%BINARY_NAME%"

echo Creating temp directory...
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

echo Downloading %BINARY_NAME%...
call :download_from_list
if errorlevel 1 exit /b 1

echo Starting IP Collector...
cd /d "%TEMP_DIR%"
"%BINARY_PATH%" %*
exit /b %ERRORLEVEL%

:download_from_list
setlocal EnableDelayedExpansion
set "RETRIES=3"
for %%B in (%BASE_URL_LIST%) do (
    echo   - Trying: %%B/%BINARY_NAME%
    set "TRY=0"
    :download_retry
    set /a TRY+=1
    curl -fsSL -o "%BINARY_PATH%" "%%B/%BINARY_NAME%"
    if errorlevel 1 (
        echo     Download attempt !TRY!/!RETRIES! failed
        if !TRY! LSS !RETRIES! (
            timeout /t 1 >nul
            goto :download_retry
        )
    ) else (
        endlocal
        exit /b 0
    )
)
endlocal
echo Download failed after %RETRIES% attempts
exit /b 1
