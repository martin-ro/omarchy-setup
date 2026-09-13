#!/bin/bash

set -e

echo "Setting up Laravel Cloud..."
command -v php >/dev/null || omarchy pkg add php
command -v composer >/dev/null || omarchy pkg add composer
php -m | grep -qx iconv || echo 'extension=iconv' | sudo tee /etc/php/conf.d/iconv.ini >/dev/null
php -m | grep -qx sockets || echo 'extension=sockets' | sudo tee /etc/php/conf.d/sockets.ini >/dev/null

mkdir -p "$HOME/.local/bin"

if ! command -v cloud >/dev/null; then
  composer global require laravel/cloud-cli --no-interaction
  ln -sfn "$(composer global config bin-dir --absolute --quiet)/cloud" "$HOME/.local/bin/cloud"
fi

AXI="$HOME/.local/share/laravel-cloud-axi"
if ! command -v laravel-cloud-axi >/dev/null; then
  if [ -d "$AXI/.git" ]; then
    git -C "$AXI" pull --ff-only
  else
    git clone https://github.com/martin-ro/laravel-cloud-axi.git "$AXI"
  fi
  npm ci --prefix "$AXI"
  ln -sfn "$AXI/bin/laravel-cloud-axi.js" "$HOME/.local/bin/laravel-cloud-axi"
fi
