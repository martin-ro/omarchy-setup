#!/bin/bash

set -e

echo "Setting up GitHub..."
if command -v gh >/dev/null && gh auth status --hostname github.com >/dev/null 2>&1; then
  echo "GitHub already authenticated."
else
  command -v gh >/dev/null || omarchy pkg add github-cli
  gh auth login --hostname github.com --git-protocol https --web
  gh auth setup-git --hostname github.com
fi
