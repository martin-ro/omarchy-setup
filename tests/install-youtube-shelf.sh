#!/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_HOME="$(mktemp -d)"
trap 'rm -rf "$TEST_HOME"' EXIT
export CALLS="$TEST_HOME/calls"

# Record commands without installing packages or changing the desktop.
omarchy() {
  printf '%s\n' "$*" >> "$CALLS"
}
export -f omarchy

HOME="$TEST_HOME" bash "$ROOT/install-youtube-shelf.sh"
printf '%s\n' \
  'pkg add mpv jq python' \
  'plugin add https://github.com/martin-ro/omarchy-youtube-shelf.git --enable --yes' \
  > "$TEST_HOME/expected"
diff -u "$TEST_HOME/expected" "$CALLS"

mkdir -p "$TEST_HOME/.config/omarchy/plugins/io.github.martin-ro.youtube-shelf"
: > "$CALLS"
HOME="$TEST_HOME" bash "$ROOT/install-youtube-shelf.sh"
printf '%s\n' \
  'pkg add mpv jq python' \
  'plugin enable io.github.martin-ro.youtube-shelf' \
  > "$TEST_HOME/expected"
diff -u "$TEST_HOME/expected" "$CALLS"

grep -Fxq '. "$DIR/install-youtube-shelf.sh"' "$ROOT/install-all.sh"
echo "YouTube Shelf installer tests passed."
