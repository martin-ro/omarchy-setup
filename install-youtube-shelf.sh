#!/bin/bash

set -e

PLUGIN_ID="io.github.martin-ro.youtube-shelf"
PLUGIN_DIR="$HOME/.config/omarchy/plugins/$PLUGIN_ID"

echo "Installing YouTube Shelf..."
omarchy pkg add mpv jq python

if [ -d "$PLUGIN_DIR" ]; then
  echo "YouTube Shelf plugin already installed."
  omarchy plugin enable "$PLUGIN_ID"
else
  omarchy plugin add https://github.com/martin-ro/omarchy-youtube-shelf.git --enable --yes
fi
