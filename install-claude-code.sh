#!/bin/bash

set -e

echo "Installing Claude Code..."
if command -v claude >/dev/null; then
  echo "Claude Code already installed."
else
  MISE_MINIMUM_RELEASE_AGE=0 mise use --global --yes claude
fi
