#!/bin/bash

set -e

echo "Installing Pi..."
if command -v pi >/dev/null; then
  echo "Pi already installed."
else
  MISE_MINIMUM_RELEASE_AGE=0 mise use --global --yes pi
fi
