#!/usr/bin/env bash
# Full install — runs all steps in order
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/scripts" && pwd)"

echo ""
echo -e "\033[1m  Cobra NixOS Setup\033[0m"
echo -e "\033[2m  KDE Plasma + Btrfs + systemd-boot\033[0m"
echo ""

bash "$SCRIPT_DIR/01-partition.sh"
bash "$SCRIPT_DIR/02-hardware.sh"
bash "$SCRIPT_DIR/03-install.sh"
bash "$SCRIPT_DIR/04-post-install.sh"
