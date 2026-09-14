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

mkdir -p \
  "$HOME/.agents" \
  "$HOME/.config/yazi" \
  "$HOME/.config/hypr" \
  "$HOME/.config/herdr" \
  "$HOME/.config/lazygit"
rm -f \
  "$HOME/.agents/AGENTS.md" \
  "$HOME/.config/yazi/yazi.toml" \
  "$HOME/.config/herdr/config.toml" \
  "$HOME/.config/lazygit/config.yml" \
  "$HOME/.bash_aliases"
for FILE in looknfeel.lua bindings.lua; do
  SOURCE="$DOTFILES/hyprland/.config/hypr/$FILE"
  TARGET="$HOME/.config/hypr/$FILE"

  if [ "$(readlink -f "$TARGET" 2>/dev/null)" != "$SOURCE" ]; then
    rm -f "$TARGET"
    HYPR_CHANGED=true
  fi
done

NVIM_SRC="$DOTFILES/nvim/.config/nvim/init.lua"
NVIM_DST="$HOME/.config/nvim/init.lua"
if [ -e "$HOME/.config/nvim" ] && [ "$(readlink -f "$NVIM_DST" 2>/dev/null)" != "$(readlink -f "$NVIM_SRC")" ]; then
  BK="$HOME/nvim-backup-$(date +%Y%m%d%H%M%S)"
  mv "$HOME/.config/nvim" "$BK"
  if [ -d "$HOME/.local/share/nvim" ]; then
    mv "$HOME/.local/share/nvim" "$BK-share"
  fi
fi

stow --no-folding --restow --dir="$DOTFILES" --target="$HOME" agents yazi hyprland bash herdr lazygit nvim

nvim --headless "+Lazy! sync" +qa || echo "nvim plugin sync will finish on first launch"

if [ "$HYPR_CHANGED" = true ]; then
  hyprctl reload
  hyprctl configerrors
fi
