#!/bin/bash

set -e

PI="$HOME/.local/bin/pi"
SETTINGS="$HOME/.pi/agent/settings.json"

echo "Installing Pi..."
"$PI" --version

mkdir -p "$HOME/.pi/agent"
rm -f "$HOME/.pi/agent/AGENTS.md" "$SETTINGS"
stow --no-folding --restow --dir="$HOME/dotfiles" --target="$HOME" pi

PACKAGES="$(jq -r '.packages[]?' "$SETTINGS")"
while IFS= read -r PACKAGE; do
  [ -n "$PACKAGE" ] || continue
  "$PI" install "$PACKAGE"
done <<< "$PACKAGES"

"$HOME/.local/bin/herdr" integration install pi

echo "Setting Pi as the default agent..."
if [ "$(omarchy default agent)" = "pi" ]; then
  echo "Pi already set as the default agent."
else
  setsid -f omarchy default agent pi >/dev/null 2>&1
fi
