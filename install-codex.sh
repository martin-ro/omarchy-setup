#!/bin/bash

set -e

CODEX="$HOME/.local/bin/codex"
CONFIG="$HOME/.codex/config.toml"

echo "Installing Codex..."
"$CODEX" --version

mkdir -p "$HOME/.codex"
rm -f "$HOME/.codex/AGENTS.md"
stow --no-folding --restow --dir="$HOME/dotfiles" --target="$HOME" codex

touch "$CONFIG"
CONFIG_CONTENT="$(awk '
BEGIN {
  print "model = \"gpt-5.6-sol\""
  print "model_reasoning_effort = \"high\""
  root = 1
}
root && /^[[:space:]]*\[/ { root = 0 }
root && /^[[:space:]]*model[[:space:]]*=/ { next }
root && /^[[:space:]]*model_reasoning_effort[[:space:]]*=/ { next }
{ print }
' "$CONFIG")"
printf '%s\n' "$CONFIG_CONTENT" > "$CONFIG"
unset CONFIG_CONTENT

if ! "$CODEX" plugin marketplace list | grep '^ponytail[[:space:]]' >/dev/null; then
  "$CODEX" plugin marketplace add DietrichGebert/ponytail
fi
if ! "$CODEX" plugin list | grep '^ponytail@ponytail[[:space:]][[:space:]]*installed, enabled' >/dev/null; then
  "$CODEX" plugin add ponytail@ponytail
fi
echo "Ponytail hooks require one-time approval in Codex /hooks."

"$HOME/.local/bin/herdr" integration install codex
