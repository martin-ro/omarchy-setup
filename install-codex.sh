#!/bin/bash

set -e

echo "Installing Codex..."
"$HOME/.local/bin/codex" --version

mkdir -p "$HOME/.codex"
rm -f "$HOME/.codex/AGENTS.md"
stow --no-folding --restow --dir="$HOME/dotfiles" --target="$HOME" codex

"$HOME/.local/bin/herdr" integration install codex
