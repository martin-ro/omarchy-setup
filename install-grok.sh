#!/bin/bash

set -e

echo "Installing Grok..."
"$HOME/.local/bin/grok" --version

mkdir -p "$HOME/.grok/rules"
rm -f "$HOME/.grok/rules/AGENTS.md"
stow --no-folding --restow --dir="$HOME/dotfiles" --target="$HOME" grok

"$HOME/.local/bin/herdr" integration install grok
