#!/bin/bash

set -e

echo "Installing Codex..."
if command -v codex >/dev/null; then
  echo "Codex already installed."
else
  MISE_MINIMUM_RELEASE_AGE=0 mise use --global --yes codex
fi
