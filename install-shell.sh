#!/bin/bash

set -e

echo "Setting shell idle times..."
source omarchy-shell-config
commit "$NORMALIZE | .idle.screensaver = 600 | .idle.lock = 900"
omarchy restart shell
