#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing macchanger service..."

sudo install -m 0755 "$SCRIPT_DIR/change-mac.sh" /usr/local/bin/change-mac.sh
sudo install -m 0644 "$SCRIPT_DIR/macchanger.service" /etc/systemd/system/macchanger.service

sudo systemctl daemon-reload

sudo systemctl enable macchanger.service

sudo systemctl restart macchanger.service

echo "[+] MAC randomizer service installed and running."

