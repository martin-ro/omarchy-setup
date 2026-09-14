#!/bin/bash

set -e

echo "Installing beelink site tunnel..."

HOST="${BEELINK_HOST:-beelink}"
UNIT_DIR="$HOME/.config/systemd/user"
UNIT="$UNIT_DIR/beelink-tunnel.service"

if ! ssh -o BatchMode=yes -o ConnectTimeout=8 "$HOST" true >/dev/null; then
  echo "Cannot ssh $HOST without a password. Connect Tailscale, then retry."
  exit 1
fi

mkdir -p "$UNIT_DIR"
cat > "$UNIT" <<EOF
[Unit]
Description=SSH tunnel to beelink Caddy (localhost:9080/9443)
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/ssh -N -o BatchMode=yes -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ConnectTimeout=10 -L 9080:127.0.0.1:9080 -L 9443:127.0.0.1:9443 $HOST
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now beelink-tunnel.service

if loginctl show-user "$USER" -p Linger 2>/dev/null | grep -q 'Linger=yes'; then
  echo "Linger already enabled."
elif sudo -n loginctl enable-linger "$USER" 2>/dev/null; then
  echo "Linger enabled."
else
  echo "Linger not enabled (need sudo). Tunnel starts at login."
fi

if ! command -v certutil >/dev/null; then
  sudo pacman -S --noconfirm --needed nss
fi

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT
if scp -o BatchMode=yes -o ConnectTimeout=8 "$HOST:.local/share/caddy/pki/authorities/local/root.crt" "$TMP"; then
  mkdir -p "$HOME/.pki/nssdb"
  if [ ! -f "$HOME/.pki/nssdb/cert9.db" ]; then
    certutil -d sql:"$HOME/.pki/nssdb" -N --empty-password
  fi
  certutil -d sql:"$HOME/.pki/nssdb" -D -n "Beelink Caddy Local Authority" 2>/dev/null || true
  certutil -d sql:"$HOME/.pki/nssdb" -A -t "C,," -n "Beelink Caddy Local Authority" -i "$TMP"
  if sudo -n trust anchor "$TMP" 2>/dev/null; then
    echo "Trusted Caddy CA system-wide."
  else
    echo "System CA not updated (need sudo). Chromium nssdb is enough."
  fi
  echo "Trusted Caddy CA in Chromium. Restart the browser if a site still warns."
else
  echo "Could not fetch Caddy CA from $HOST. Sites work after you accept the cert warning."
fi

echo "Beelink tunnel is up. Open https://<site>.localhost:9443"
