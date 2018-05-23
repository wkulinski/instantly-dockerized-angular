#!/usr/bin/env bash

set -e

if [ ! -f ./ins ]; then
    echo "No local ins file. Make sure you are in project root folder."
    exit 1
fi

./ins "$@"
