#!/usr/bin/env bash

set -e

echo "Coping file..."
cp ./bash/internal/ins.sh /usr/local/bin/ins

echo "Making executable..."
chmod +x /usr/local/bin/ins

echo "Clearing cache..."
hash -r

echo "Export done."