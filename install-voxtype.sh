#!/bin/bash

set -e

echo "Installing Voxtype..."
if command -v voxtype >/dev/null; then
  echo "Voxtype already installed."
else
  if [ "$(uname -m)" = "aarch64" ]; then
    omarchy pkg add wtype
    omarchy pkg aur add voxtype
  else
    omarchy pkg add wtype voxtype-bin
  fi

  mkdir -p "$HOME/.config/voxtype"
  if [ ! -f "$HOME/.config/voxtype/config.toml" ]; then
    cp "${OMARCHY_PATH:-/usr/share/omarchy}/default/voxtype/config.toml" "$HOME/.config/voxtype/"
  fi

  voxtype setup --download --model base.en --no-post-install
  if omarchy-hw-vulkan; then
    voxtype setup gpu --enable || true
  fi
  voxtype setup systemd
fi

BINDINGS="$HOME/.config/hypr/bindings.lua"
if [ -f "$BINDINGS" ] && ! grep -q 'SUPER + D".*voxtype record toggle' "$BINDINGS"; then
  printf '\no.bind("SUPER + D", "Toggle dictation", "voxtype record toggle")\n' >> "$BINDINGS"
  hyprctl reload
  hyprctl configerrors
fi
