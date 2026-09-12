#!/bin/bash

set -e

AGENTS=(pi claude-code codex grok)

echo "Installing AXI skills..."
npx -y skills add kunchenguid/gh-axi --skill gh-axi --global --agent "${AGENTS[@]}" --yes
npx -y skills add kunchenguid/chrome-devtools-axi --skill chrome-devtools-axi --global --agent "${AGENTS[@]}" --yes
npx -y skills add martin-ro/laravel-cloud-axi --skill laravel-cloud-axi --global --agent "${AGENTS[@]}" --yes
npx -y skills add martin-ro/clickup-axi --skill clickup-axi --global --agent "${AGENTS[@]}" --yes
