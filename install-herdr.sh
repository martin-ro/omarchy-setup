#!/bin/bash

set -e

HERDR="$HOME/.local/bin/herdr"

echo "Installing Herdr..."
omarchy pkg drop herdr herdr-bin
omarchy mise install herdr
"$HERDR" --version

if "$HERDR" plugin list | grep -q 'martinro.next-agent'; then
  echo "Herdr Next Agent plugin already installed."
else
  "$HERDR" plugin install martin-ro/herdr-next-agent --yes
fi
