#!/usr/bin/env bash
# ============================================================
#  Cobra NixOS Auto-Installer
#  Partitions disk (disko), generates hardware config, installs.
#  Run this from the NixOS live ISO.
# ============================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}[*]${NC} $1"; }
ok()    { echo -e "${GREEN}[✓]${NC} $1"; }
err()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }
warn()  { echo -e "${RED}[!]${NC} $1"; }

REPO_URL="https://github.com/rayone121/cobra-nix-config.git"
FLAKE_HOST="cobra"
INSTALL_DIR="/mnt"
CONFIG_DIR="/tmp/cobra-nix-config"

# ============================================================
#  Step 1: Check environment
# ============================================================
echo ""
echo -e "${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}║     Cobra NixOS Auto-Installer       ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""

[[ $EUID -eq 0 ]] || err "Run this as root: sudo bash install.sh"

command -v nix   >/dev/null 2>&1 || err "Nix not found. Are you booted into the NixOS installer ISO?"
command -v git   >/dev/null 2>&1 || nix-env -iA nixos.git

# ============================================================
#  Step 2: Select disk
# ============================================================
info "Available disks:"
echo ""
lsblk -d -o NAME,SIZE,MODEL,TRAN | grep -v "loop\|sr\|ram"
echo ""

read -rp "$(echo -e "${CYAN}Enter target disk (e.g. nvme0n1, sda): ${NC}")" DISK_NAME
DISK="/dev/${DISK_NAME}"

[[ -b "$DISK" ]] || err "Disk $DISK does not exist."

DISK_SIZE=$(lsblk -d -n -o SIZE "$DISK" | xargs)
DISK_MODEL=$(lsblk -d -n -o MODEL "$DISK" | xargs)

echo ""
warn "This will ERASE ALL DATA on ${BOLD}${DISK}${NC} (${DISK_MODEL} — ${DISK_SIZE})"
read -rp "$(echo -e "${RED}Type 'yes' to confirm: ${NC}")" CONFIRM
[[ "$CONFIRM" == "yes" ]] || err "Aborted."

# ============================================================
#  Step 3: Detect CPU vendor
# ============================================================
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
if [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
    KVM_MODULE="kvm-amd"
    CPU_UCODE="amd"
    info "Detected AMD CPU"
elif [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
    KVM_MODULE="kvm-intel"
    CPU_UCODE="intel"
    info "Detected Intel CPU"
else
    KVM_MODULE="kvm-intel"
    CPU_UCODE="intel"
    warn "Unknown CPU vendor ($CPU_VENDOR), defaulting to Intel"
fi

# ============================================================
#  Step 4: Clone config
# ============================================================
info "Cloning config..."
if [[ -d "$CONFIG_DIR" ]]; then
    rm -rf "$CONFIG_DIR"
fi

# Try git clone, fall back to local copy if on the installer with the repo
if git clone "$REPO_URL" "$CONFIG_DIR" 2>/dev/null; then
    ok "Cloned from remote"
elif [[ -f "/root/cobra-nix-config/flake.nix" ]]; then
    cp -r /root/cobra-nix-config "$CONFIG_DIR"
    ok "Copied from /root/cobra-nix-config"
else
    # If running the script from within the repo
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$SCRIPT_DIR/flake.nix" ]]; then
        cp -r "$SCRIPT_DIR" "$CONFIG_DIR"
        ok "Copied from script directory"
    else
        err "Cannot find config repo. Clone it manually to $CONFIG_DIR"
    fi
fi

# ============================================================
#  Step 5: Patch disk device in disko config
# ============================================================
info "Setting target disk to ${DISK} in disko config..."
sed -i "s|device = \"/dev/nvme0n1\";|device = \"${DISK}\";|" "$CONFIG_DIR/hosts/cobra/disk.nix"
ok "disk.nix patched"

# ============================================================
#  Step 6: Run disko (partition + format + mount)
# ============================================================
info "Running disko — partitioning and formatting ${DISK}..."
nix run github:nix-community/disko -- --mode disko "$CONFIG_DIR/hosts/cobra/disk.nix"
ok "Disko complete — disk partitioned, formatted, and mounted at /mnt"

# ============================================================
#  Step 7: Generate hardware config
# ============================================================
info "Generating hardware configuration..."
nixos-generate-config --no-filesystems --root "$INSTALL_DIR" --dir /tmp/hw-config

# Patch CPU-specific settings
HW_CONFIG="/tmp/hw-config/hardware-configuration.nix"

if [[ "$CPU_UCODE" == "amd" ]]; then
    sed -i 's/kvm-intel/kvm-amd/' "$HW_CONFIG"
    sed -i 's/hardware\.cpu\.intel/hardware.cpu.amd/' "$HW_CONFIG"
fi

# Copy generated hardware config into our flake
cp "$HW_CONFIG" "$CONFIG_DIR/hosts/cobra/hardware-configuration.nix"

# Ensure we keep our needed options that nixos-generate-config might not add
if ! grep -q "hardware.graphics.enable" "$CONFIG_DIR/hosts/cobra/hardware-configuration.nix"; then
    sed -i '/^}$/i\  hardware.graphics.enable = true;' "$CONFIG_DIR/hosts/cobra/hardware-configuration.nix"
fi

ok "Hardware config generated and patched"

# ============================================================
#  Step 8: Copy config to target
# ============================================================
info "Copying config to ${INSTALL_DIR}/etc/nixos..."
mkdir -p "${INSTALL_DIR}/etc/nixos"
cp -r "$CONFIG_DIR"/. "${INSTALL_DIR}/etc/nixos/"
ok "Config installed"

# ============================================================
#  Step 9: Install NixOS
# ============================================================
info "Installing NixOS (this will take a while)..."
nixos-install --flake "${INSTALL_DIR}/etc/nixos#${FLAKE_HOST}" --no-root-passwd

# ============================================================
#  Step 10: Set user password
# ============================================================
echo ""
info "Set password for user 'raymond':"
nixos-enter --root "$INSTALL_DIR" -- passwd raymond

# ============================================================
#  Done!
# ============================================================
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║      Installation complete! 🐍       ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "  Disk:     ${BOLD}${DISK}${NC} (${DISK_MODEL})"
echo -e "  CPU:      ${BOLD}${CPU_UCODE}${NC}"
echo -e "  FS:       ${BOLD}btrfs${NC} with @, @home, @nix, @log, @snapshots"
echo -e "  Boot:     ${BOLD}Limine${NC} (Catppuccin Mocha)"
echo -e "  Desktop:  ${BOLD}Niri${NC} (macOS-style)"
echo -e "  Config:   ${BOLD}/etc/nixos${NC}"
echo ""
echo -e "  Run ${CYAN}reboot${NC} to start your new system."
echo ""
