#!/bin/bash

set -e

GROK="$HOME/.local/bin/grok"

echo "Installing Grok..."
"$GROK" --version

mkdir -p "$HOME/.grok/rules"
rm -f "$HOME/.grok/rules/AGENTS.md"
stow --no-folding --restow --dir="$HOME/dotfiles" --target="$HOME" grok

if "$GROK" plugin details ponytail >/dev/null 2>&1; then
  echo "Ponytail plugin already installed."
else
  "$GROK" plugin install DietrichGebert/ponytail --trust
fi
"$GROK" plugin enable ponytail

"$HOME/.local/bin/herdr" integration install grok
