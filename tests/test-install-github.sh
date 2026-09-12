#!/bin/bash

set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export CALLS="$TMP/calls"

# Run with fake commands so no packages, credentials, or user config change.
for SCENARIO in authenticated missing logged-out login-failure setup-failure; do
  export SCENARIO
  : > "$CALLS"
  status=0
  bash -c '
    command() {
      if [[ "$*" == "-v gh" ]]; then
        [[ "$SCENARIO" != missing ]]
      else
        builtin command "$@"
      fi
    }
    omarchy() { printf "omarchy %s\n" "$*" >> "$CALLS"; }
    gh() {
      printf "gh %s\n" "$*" >> "$CALLS"
      case "$1 $2" in
        "auth status") [[ "$SCENARIO" == authenticated || "$SCENARIO" == setup-failure ]] ;;
        "auth login") [[ "$SCENARIO" != login-failure ]] ;;
        "auth setup-git") [[ "$SCENARIO" != setup-failure ]] ;;
      esac
    }
    source "$1"
  ' bash "$DIR/install-github.sh" > "$TMP/output" 2>&1 || status=$?

  {
    if [[ "$SCENARIO" == missing ]]; then
      echo 'omarchy pkg add github-cli'
    fi
    echo 'gh auth status --hostname github.com'
    if [[ "$SCENARIO" != authenticated && "$SCENARIO" != setup-failure ]]; then
      echo 'gh auth login --hostname github.com --git-protocol https --web'
    fi
    if [[ "$SCENARIO" != login-failure ]]; then
      echo 'gh config set git_protocol https --host github.com'
      echo 'gh auth setup-git --hostname github.com'
    fi
  } > "$TMP/expected"

  expected_status=0
  case "$SCENARIO" in
    login-failure|setup-failure) expected_status=1 ;;
  esac
  if [[ "$status" != "$expected_status" ]]; then
    printf '%s: expected exit %s, got %s\n' "$SCENARIO" "$expected_status" "$status" >&2
    exit 1
  fi
  diff -u "$TMP/expected" "$CALLS"
done

echo 'GitHub setup checks passed.'
