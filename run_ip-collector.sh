#!/bin/bash

set -e

echo -e "\033[36mIP Collector - One-Click Runner\033[0m"

DEFAULT_RAW_BASE_URL="https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/linux"
DEFAULT_CDN_BASE_URL="https://cdn.jsdelivr.net/gh/laohuyou886/ip-deploy@main/bin/linux"
DEFAULT_GHPROXY_BASE_URL="https://ghproxy.com/${DEFAULT_RAW_BASE_URL}"

if [ -n "${IP_COLLECTOR_RELEASE_URL:-}" ]; then
    BASE_URLS=("${IP_COLLECTOR_RELEASE_URL}")
else
    useCdn="${IP_COLLECTOR_USE_CDN:-1}"
    useCdn="$(echo "$useCdn" | tr -d '[:space:]')"
    if [ "$useCdn" = "0" ] || [ "$useCdn" = "false" ] || [ "$useCdn" = "FALSE" ] || [ "$useCdn" = "no" ] || [ "$useCdn" = "NO" ]; then
        BASE_URLS=("${DEFAULT_RAW_BASE_URL}" "${DEFAULT_CDN_BASE_URL}" "${DEFAULT_GHPROXY_BASE_URL}")
    else
        BASE_URLS=("${DEFAULT_CDN_BASE_URL}" "${DEFAULT_RAW_BASE_URL}" "${DEFAULT_GHPROXY_BASE_URL}")
    fi
fi

BINARY_NAME="ip-collector"
TEMP_DIR="/tmp/ip-collector-$(date +%Y%m%d-%H%M%S)-$$"
BINARY_PATH="$TEMP_DIR/$BINARY_NAME"

echo "Creating temp directory..."
mkdir -p "$TEMP_DIR"

echo "Downloading $BINARY_NAME..."
ok=0
for base in "${BASE_URLS[@]}"; do
    echo "  - Trying: $base/$BINARY_NAME"
    for i in 1 2 3; do
        if curl -fsSL -o "$BINARY_PATH" "$base/$BINARY_NAME"; then
            ok=1
            break
        fi
        echo "    Download attempt $i/3 failed"
        sleep 1
    done
    if [ "$ok" -eq 1 ]; then
        break
    fi
done
if [ "$ok" -ne 1 ]; then
    echo -e "\033[31mDownload failed after 3 attempts\033[0m"
    exit 1
fi

echo "Adding execute permission..."
chmod +x "$BINARY_PATH"

echo -e "\033[32mStarting IP Collector...\033[0m"
cd "$TEMP_DIR"
exec "./$BINARY_NAME" "$@"
