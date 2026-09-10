#!/bin/bash

set -e

echo "Setting Pi as the default agent..."
if [ "$(omarchy default agent)" = "pi" ]; then
  echo "Pi already set as the default agent."
else
  setsid -f omarchy default agent pi >/dev/null 2>&1
fi
