#!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"

. "$DIR/install-chromium-account.sh"
. "$DIR/install-tailscale.sh"
. "$DIR/install-bitwarden.sh"
. "$DIR/install-github.sh"
. "$DIR/install-stow.sh"
. "$DIR/install-yazi.sh"
. "$DIR/install-dotfiles.sh"

echo "Done."
