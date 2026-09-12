#!/bin/bash

set -e

CLAUDE="$HOME/.local/bin/claude"

echo "Installing Claude Code..."
"$CLAUDE" --version

mkdir -p "$HOME/.claude"
rm -f "$HOME/.claude/CLAUDE.md" "$HOME/.claude/settings.json"
stow --no-folding --restow --dir="$HOME/dotfiles" --target="$HOME" claude

"$CLAUDE" plugin marketplace add DietrichGebert/ponytail --scope user
"$CLAUDE" plugin install ponytail@ponytail --scope user --yes

"$HOME/.local/bin/herdr" integration install claude
