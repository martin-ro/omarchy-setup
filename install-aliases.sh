#!/bin/bash

set -e

echo "Installing aliases..."
if ! grep -q '\.bash_aliases' "$HOME/.bashrc" 2>/dev/null; then
  printf '\n%s\n' 'source "$HOME/.bash_aliases"' >> "$HOME/.bashrc"
fi
