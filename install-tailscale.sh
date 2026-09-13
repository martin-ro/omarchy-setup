#!/bin/bash

set -e

echo "Setting up Tailscale..."
if omarchy installed service tailscale; then
  echo "Tailscale already connected."
else
  omarchy install service tailscale
fi

if ! command -v tailscale >/dev/null; then
  echo "Tailscale CLI is not available."
  exit 1
fi

if tailscale debug prefs 2>/dev/null | grep -q '"RunSSH": true'; then
  echo "Tailscale SSH already enabled."
else
  echo "Enabling Tailscale SSH..."
  sudo tailscale set --ssh
fi
