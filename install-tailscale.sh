#!/bin/bash

set -e

echo "Setting up Tailscale..."
command -v tailscale >/dev/null || omarchy pkg add tailscale
if ! command -v tailscale >/dev/null; then
  echo "Tailscale is not installed."
  exit 1
fi

if tailscale status --json 2>/dev/null | grep -q '"BackendState": "Running"'; then
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
