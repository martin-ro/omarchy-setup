#!/bin/bash

set -e

echo "Setting up Laravel Cloud..."
command -v php >/dev/null || omarchy pkg add php
command -v composer >/dev/null || omarchy pkg add composer

if ! command -v cloud >/dev/null; then
  composer global require laravel/cloud-cli --no-interaction
  mkdir -p "$HOME/.local/bin"
  ln -sfn "$(composer global config bin-dir --absolute --quiet)/cloud" "$HOME/.local/bin/cloud"
fi

if [ -f "$HOME/.config/cloud/config.json" ]; then
  echo "Laravel Cloud already authenticated."
else
  cloud auth
fi
