#!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
BEFORE_PULL="$(git -C "$DIR" rev-parse HEAD)"
git -C "$DIR" pull --ff-only
AFTER_PULL="$(git -C "$DIR" rev-parse HEAD)"

if [ "$BEFORE_PULL" != "$AFTER_PULL" ]; then
  exec "$DIR/install-all.sh" "$@"
fi

. "$DIR/install-chromium-account.sh"
. "$DIR/install-tailscale.sh"
. "$DIR/install-bitwarden.sh"
. "$DIR/install-github.sh"
. "$DIR/install-pi.sh"
. "$DIR/install-grok.sh"
. "$DIR/install-codex.sh"
. "$DIR/install-claude-code.sh"
. "$DIR/install-stow.sh"
. "$DIR/install-yazi.sh"
. "$DIR/install-dotfiles.sh"
. "$DIR/install-aliases.sh"
. "$DIR/install-shell.sh"
. "$DIR/install-default-agent.sh"

echo "Done."
