#!/bin/bash

set -e

echo "Enabling Chromium account..."
if grep -q oauth2-client-id "$HOME/.config/chromium-flags.conf" 2>/dev/null; then
  echo "Chromium account already enabled."
else
  omarchy install chromium google account

  if pgrep -x chromium >/dev/null; then
    read -rp "Close Chromium, then press Enter... "
  fi

  setsid -f uwsm-app -- chromium "chrome://settings/people" >/dev/null 2>&1
  read -rp "Log in to Chromium and wait for Bitwarden to sync, then press Enter... "
fi
