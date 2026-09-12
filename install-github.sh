#!/bin/bash

set -e

echo "Setting up GitHub..."
command -v gh >/dev/null || omarchy pkg add github-cli
if gh auth status --hostname github.com >/dev/null 2>&1; then
  echo "GitHub already authenticated."
else
  gh auth login --hostname github.com --git-protocol https --web
fi

gh config set git_protocol https --host github.com
gh auth setup-git --hostname github.com
