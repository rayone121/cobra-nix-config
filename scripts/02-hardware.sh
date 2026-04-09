#!/usr/bin/env bash
# Generate hardware configuration
set -euo pipefail
source "$(dirname "$0")/lib.sh"

info "Generating hardware configuration..."
nixos-generate-config --no-filesystems --root /mnt --dir /tmp/hw-config

cp /tmp/hw-config/hardware-configuration.nix "$REPO_DIR/hosts/cobra/hardware-configuration.nix"

# Ensure graphics enabled
if ! grep -q "hardware.graphics.enable" "$REPO_DIR/hosts/cobra/hardware-configuration.nix"; then
    sed -i '/^}$/i\  hardware.graphics.enable = true;' "$REPO_DIR/hosts/cobra/hardware-configuration.nix"
fi

ok "Hardware config written to hosts/cobra/hardware-configuration.nix"
