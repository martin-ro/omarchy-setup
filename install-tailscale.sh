#!/bin/bash

set -e

echo "Setting up Tailscale..."
if tailscale status --json 2>/dev/null | grep -q '"BackendState": "Running"'; then
  echo "Tailscale already connected."
else
  omarchy install service tailscale
fi
