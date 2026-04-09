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
# Run stow directly from host — /mnt is still mounted
DOTFILES="/mnt/home/${USERNAME}/.config/nixos/dotfiles"
TARGET="/mnt/home/${USERNAME}"
for pkg in niri waybar kitty dunst fuzzel swaylock matugen scripts cobra; do
    if [[ -d "${DOTFILES}/${pkg}" ]]; then
        # Manual symlink since stow might not be in PATH inside chroot
        find "${DOTFILES}/${pkg}" -type f | while read -r src; do
            rel="${src#${DOTFILES}/${pkg}/}"
            dest="${TARGET}/${rel}"
            mkdir -p "$(dirname "$dest")"
            ln -sf "$src" "$dest"
        done
    fi
done

ok "Done! Run ${CYAN}reboot${NC} to start your new system."
