#!/bin/bash

set -e

DOTFILES="$HOME/Work/dotfiles"
BEFORE_HYPR=""

if [ -d "$DOTFILES/.git" ]; then
  BEFORE_HYPR="$(git -C "$DOTFILES" rev-parse HEAD:hyprland 2>/dev/null || true)"
  if git -C "$DOTFILES" rev-parse --abbrev-ref @{upstream} >/dev/null 2>&1; then
    git -C "$DOTFILES" pull --ff-only
  fi
elif [ ! -e "$DOTFILES" ]; then
  mkdir -p "$(dirname "$DOTFILES")"
  git clone https://github.com/martin-ro/dotfiles.git "$DOTFILES"
fi

AFTER_HYPR="$(git -C "$DOTFILES" rev-parse HEAD:hyprland 2>/dev/null || true)"
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
  "$HOME/.config/starship.toml" \
  "$HOME/.bash_aliases"
for FILE in looknfeel.lua bindings.lua; do
  SOURCE="$DOTFILES/hyprland/.config/hypr/$FILE"
  TARGET="$HOME/.config/hypr/$FILE"

  if [ "$(readlink -f "$TARGET" 2>/dev/null)" != "$SOURCE" ]; then
    rm -f "$TARGET"
    HYPR_CHANGED=true
  fi
done

OLD_DOTFILES="$HOME/dotfiles"
if [ -d "$OLD_DOTFILES" ] && [ "$(readlink -f "$OLD_DOTFILES")" != "$(readlink -f "$DOTFILES")" ]; then
  stow --no-folding -D --dir="$OLD_DOTFILES" --target="$HOME" agents yazi hyprland bash herdr lazygit nvim || true
fi

NVIM_DST="$HOME/.config/nvim/init.lua"
if [ -e "$HOME/.config/nvim" ] && [ ! -L "$NVIM_DST" ]; then
  BK="$HOME/nvim-backup-$(date +%Y%m%d%H%M%S)"
  mv "$HOME/.config/nvim" "$BK"
  if [ -d "$HOME/.local/share/nvim" ]; then
    mv "$HOME/.local/share/nvim" "$BK-share"
  fi
fi

stow --no-folding --restow --dir="$DOTFILES" --target="$HOME" agents yazi hyprland bash herdr lazygit nvim starship bin

nvim --headless "+Lazy! sync" +qa || echo "nvim plugin sync will finish on first launch"

if [ "$HYPR_CHANGED" = true ]; then
  hyprctl reload
  hyprctl configerrors
fi
