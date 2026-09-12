#!/bin/bash

set -e

PLUGIN_ID="martin.timers"
PLUGIN_DIR="$HOME/.config/omarchy/plugins/$PLUGIN_ID"

echo "Installing Omarchy Project Timers..."
if [ -d "$PLUGIN_DIR" ]; then
  echo "Project Timers plugin already installed."
  omarchy plugin enable "$PLUGIN_ID"
else
  omarchy plugin add https://github.com/martin-ro/omarchy-timers.git --enable --yes
fi
