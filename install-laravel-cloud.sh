#!/bin/bash

set -e

echo "Setting up Laravel Cloud..."
command -v php >/dev/null || omarchy pkg add php
command -v composer >/dev/null || omarchy pkg add composer
php -m | grep -qx iconv || echo 'extension=iconv' | sudo tee /etc/php/conf.d/iconv.ini >/dev/null
php -m | grep -qx sockets || echo 'extension=sockets' | sudo tee /etc/php/conf.d/sockets.ini >/dev/null

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
