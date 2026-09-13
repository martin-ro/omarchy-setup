#!/bin/bash

set -e

echo "Setting up Tailscale..."
if ! command -v tailscale >/dev/null; then
  sudo pacman -Sy --noconfirm --needed tailscale
fi

if ! command -v tailscale >/dev/null; then
  echo "Tailscale package is not available."
  exit 1
fi

if omarchy installed service tailscale; then
  echo "Tailscale already connected."
else
  omarchy install service tailscale
fi

if tailscale debug prefs 2>/dev/null | grep -q '"RunSSH": true'; then
  echo "Tailscale SSH already enabled."
else
  echo "Enabling Tailscale SSH..."
  sudo tailscale set --ssh
fi
