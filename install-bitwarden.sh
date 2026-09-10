#!/bin/bash

set -e

echo "Installing Bitwarden..."
if omarchy pkg present bitwarden; then
  echo "Bitwarden already installed."
else
  omarchy pkg add bitwarden bitwarden-cli
  setsid -f uwsm-app -- gtk-launch bitwarden >/dev/null 2>&1
  read -rp "Log in to Bitwarden, then press Enter... "
fi
