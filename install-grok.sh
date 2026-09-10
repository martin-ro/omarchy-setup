#!/bin/bash

set -e

echo "Installing Grok..."
if command -v grok >/dev/null; then
  echo "Grok already installed."
else
  MISE_MINIMUM_RELEASE_AGE=0 mise use --global --yes node "npm:@xai-official/grok"
fi
