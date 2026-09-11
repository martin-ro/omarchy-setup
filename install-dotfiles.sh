#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"
BEFORE_HYPR=""

if [ -d "$DOTFILES/.git" ]; then
  BEFORE_HYPR="$(git -C "$DOTFILES" rev-parse HEAD:hyprland 2>/dev/null || true)"
  git -C "$DOTFILES" pull --ff-only
else
  git clone https://github.com/martin-ro/dotfiles.git "$DOTFILES"
fi

AFTER_HYPR="$(git -C "$DOTFILES" rev-parse HEAD:hyprland)"
HYPR_CHANGED=false
[ "$BEFORE_HYPR" = "$AFTER_HYPR" ] || HYPR_CHANGED=true

mkdir -p "$HOME/.config/yazi" "$HOME/.config/hypr" "$HOME/.config/herdr" "$HOME/.config/lazygit"
rm -f "$HOME/.config/yazi/yazi.toml" "$HOME/.config/herdr/config.toml" "$HOME/.config/lazygit/config.yml" "$HOME/.bash_aliases"

for FILE in looknfeel.lua bindings.lua; do
  SOURCE="$DOTFILES/hyprland/.config/hypr/$FILE"
  TARGET="$HOME/.config/hypr/$FILE"

  if [ "$(readlink -f "$TARGET" 2>/dev/null)" != "$SOURCE" ]; then
    rm -f "$TARGET"
    HYPR_CHANGED=true
  fi
done

stow --restow --dir="$DOTFILES" --target="$HOME" yazi hyprland bash herdr lazygit

if [ "$HYPR_CHANGED" = true ]; then
  hyprctl reload
  hyprctl configerrors
fi
