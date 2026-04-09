#!/usr/bin/env bash
# Set password and fix ownership
set -euo pipefail
source "$(dirname "$0")/lib.sh"

USERNAME=$($NIX eval --raw -f "$REPO_DIR/config.nix" username)

info "Set password for '${USERNAME}':"
nixos-enter --root /mnt -- passwd "$USERNAME"

# Fix ownership — the entire home dir tree was created as root during install
info "Fixing ownership..."
nixos-enter --root /mnt -- chown -R "${USERNAME}:users" "/home/${USERNAME}"

ok "Done! Run ${CYAN}reboot${NC} to start your new system."
