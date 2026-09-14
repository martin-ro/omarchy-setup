#!/bin/bash

set -e

echo "Installing Omarchy theme switcher..."
if [ -x "$HOME/Work/omarchy-theme-switcher/install.sh" ]; then
  "$HOME/Work/omarchy-theme-switcher/install.sh"
elif [ -d "$HOME/omarchy-theme-switcher/.git" ]; then
  git -C "$HOME/omarchy-theme-switcher" pull --ff-only
  "$HOME/omarchy-theme-switcher/install.sh"
else
  git clone https://github.com/martin-ro/omarchy-theme-switcher.git "$HOME/omarchy-theme-switcher"
  "$HOME/omarchy-theme-switcher/install.sh"
fi
