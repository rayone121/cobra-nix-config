#!/usr/bin/env bash
# Set password, fix ownership, stow dotfiles
set -euo pipefail
source "$(dirname "$0")/lib.sh"

USERNAME=$($NIX eval --raw -f "$REPO_DIR/config.nix" username)

info "Set password for '${USERNAME}':"
nixos-enter --root /mnt -- passwd "$USERNAME"

info "Fixing ownership..."
nixos-enter --root /mnt -- chown -R "${USERNAME}:users" "/home/${USERNAME}"

info "Stowing dotfiles..."
nixos-enter --root /mnt -- su "$USERNAME" -l -c \
  "cd /home/${USERNAME}/.config/nixos && PATH=/run/current-system/sw/bin:\$PATH bash stow.sh"

ok "Done! Run ${CYAN}reboot${NC} to start your new system."
