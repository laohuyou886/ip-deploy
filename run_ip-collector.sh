#!/bin/bash

set -e

echo -e "\033[36mIP Collector - One-Click Runner\033[0m"

BASE_URL="${IP_COLLECTOR_RELEASE_URL:-https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/linux}"
BINARY_NAME="ip-collector"
TEMP_DIR="/tmp/ip-collector-$(date +%Y%m%d-%H%M%S)-$$"
BINARY_PATH="$TEMP_DIR/$BINARY_NAME"

echo "Creating temp directory..."
mkdir -p "$TEMP_DIR"

echo "Downloading $BINARY_NAME from $BASE_URL..."
ok=0
for i in 1 2 3; do
    if curl -fsSL -o "$BINARY_PATH" "$BASE_URL/$BINARY_NAME"; then
        ok=1
        break
    fi
    echo "Download attempt $i/3 failed"
    sleep 1
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
