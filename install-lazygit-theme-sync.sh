#!/bin/bash

set -e

REPO="$HOME/omarchy-lazygit-theme-sync"

echo "Installing Omarchy Lazygit theme sync..."
if [ -d "$REPO/.git" ]; then
  git -C "$REPO" pull --ff-only
else
  git clone https://github.com/martin-ro/omarchy-lazygit-theme-sync.git "$REPO"
fi

"$REPO/install.sh"
