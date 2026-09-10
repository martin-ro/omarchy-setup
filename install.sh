#!/bin/bash

set -e

echo "Enabling Chromium account..."
omarchy install chromium google account

if pgrep -x chromium >/dev/null; then
  read -rp "Close Chromium, then press Enter... "
fi

echo "Installing Bitwarden..."
omarchy pkg add bitwarden bitwarden-cli
setsid -f uwsm-app -- gtk-launch bitwarden >/dev/null 2>&1
read -rp "Log in to Bitwarden, then press Enter... "

echo "Opening Chromium..."
setsid -f uwsm-app -- chromium "chrome://settings/people" >/dev/null 2>&1
read -rp "Log in to Chromium and wait for Bitwarden to sync, then press Enter... "

echo "Setting up Tailscale..."
if ! tailscale status --json 2>/dev/null | grep -q '"BackendState": "Running"'; then
  omarchy install service tailscale
fi

echo "Setting up GitHub..."
command -v gh >/dev/null || omarchy pkg add github-cli

if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  gh auth login --hostname github.com --git-protocol https --web
fi

gh auth setup-git --hostname github.com

echo "Done."
