#!/bin/bash

set -e

echo "Enabling Bluetooth..."
if omarchy bluetooth power is-on; then
  echo "Bluetooth already on."
else
  omarchy bluetooth power on
fi
