#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

if [ ! -d "$DOTFILES/.git" ]; then
  git clone https://github.com/martin-ro/dotfiles.git "$DOTFILES"
fi

mkdir -p "$HOME/.config/yazi"
rm -f "$HOME/.config/yazi/yazi.toml"

stow --restow --dir="$DOTFILES" --target="$HOME" yazi
