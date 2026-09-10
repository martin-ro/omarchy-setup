#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

if [ -d "$DOTFILES/.git" ]; then
  git -C "$DOTFILES" pull --ff-only
else
  git clone https://github.com/martin-ro/dotfiles.git "$DOTFILES"
fi

mkdir -p "$HOME/.config/yazi" "$HOME/.config/hypr"
rm -f "$HOME/.config/yazi/yazi.toml" "$HOME/.config/hypr/looknfeel.lua" "$HOME/.config/hypr/bindings.lua"

stow --restow --dir="$DOTFILES" --target="$HOME" yazi hyprland
hyprctl reload
hyprctl configerrors
