#!/bin/bash

set -e

# Required by the Lazygit configuration in dotfiles.
# Provides the delta pager configured in the Lazygit dotfiles.
echo "Installing Git Delta for Lazygit..."
omarchy pkg add git-delta
