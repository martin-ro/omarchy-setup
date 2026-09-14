#!/bin/bash

set -e

echo "Installing Google Drive..."
if omarchy pkg present rclone; then
  echo "rclone already installed."
else
  omarchy pkg add rclone
fi

mkdir -p "$HOME/GoogleDrive" "$HOME/.config/systemd/user"

if rclone listremotes 2>/dev/null | grep -qx 'gdrive:'; then
  echo "Google Drive already configured."
else
  rclone config create gdrive drive scope drive
fi

UNIT="$HOME/.config/systemd/user/rclone-gdrive.service"
cat > "$UNIT" <<'EOF'
[Unit]
Description=Google Drive (rclone mount)
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount gdrive: %h/GoogleDrive \
  --vfs-cache-mode full \
  --vfs-cache-max-size 10G \
  --vfs-cache-max-age 168h \
  --dir-cache-time 72h
ExecStop=/usr/bin/fusermount3 -u %h/GoogleDrive
Restart=on-failure
RestartSec=10
TimeoutStopSec=20

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now rclone-gdrive.service
