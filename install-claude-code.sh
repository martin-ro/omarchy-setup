#!/bin/bash

set -e

echo "Installing Claude Code..."
"$HOME/.local/bin/claude" --version

mkdir -p "$HOME/.claude"
rm -f "$HOME/.claude/CLAUDE.md"
stow --no-folding --restow --dir="$HOME/dotfiles" --target="$HOME" claude

"$HOME/.local/bin/herdr" integration install claude
