#!/usr/bin/env bash
# Copy config and run nixos-install
set -euo pipefail
source "$(dirname "$0")/lib.sh"

HOSTNAME=$($NIX eval --raw -f "$REPO_DIR/config.nix" hostname)
USERNAME=$($NIX eval --raw -f "$REPO_DIR/config.nix" username)
GIT_NAME=$($NIX eval --raw -f "$REPO_DIR/config.nix" gitName)
GIT_EMAIL=$($NIX eval --raw -f "$REPO_DIR/config.nix" gitEmail)

USER_CONFIG="/mnt/home/${USERNAME}/.config/nixos"

info "Copying config to ${USER_CONFIG}..."
mkdir -p "$USER_CONFIG"
cp -r "$REPO_DIR"/. "$USER_CONFIG/"

# Git init so flake can find files
git -C "$USER_CONFIG" init -q
git -C "$USER_CONFIG" add -A
git -C "$USER_CONFIG" add -f hosts/cobra/hardware-configuration.nix
git -C "$USER_CONFIG" -c user.name="$GIT_NAME" -c user.email="$GIT_EMAIL" \
  commit -q -m "Initial config"

ok "Config installed"

info "Installing NixOS (this will take a while)..."
nixos-install --flake "${USER_CONFIG}#${HOSTNAME}" --no-root-passwd

ok "NixOS installed"
