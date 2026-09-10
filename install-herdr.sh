#!/bin/bash

set -e

echo "Installing Herdr..."
omarchy pkg drop herdr herdr-bin
omarchy mise install herdr
"$HOME/.local/bin/herdr" --version
