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
YELLOW='\033[0;33m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}[*]${NC} $1"; }
ok()    { echo -e "${GREEN}[+]${NC} $1"; }
err()   { echo -e "${RED}[!]${NC} $1"; exit 1; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }

REPO_URL="https://github.com/rayone121/cobra-nix-config.git"
FLAKE_HOST="cobra"
INSTALL_DIR="/mnt"
CONFIG_DIR="/tmp/cobra-nix-config"

# ============================================================
#  Banner
# ============================================================
clear
echo -e "${CYAN}"
cat << 'COBRA'

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢔⣫⣭⣭⣒⣒⠦⢤⣀⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣵⣿⠿⠋⠀⠀⠉⠙⠓⣶⣬⣙⠲⢄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠟⠁⠀⢀⡴⠶⣤⡀⠀⢈⠑⠊⠿⡆⠑⣄⠀
⠀⠀⠀⠀⠀⠀⠀⢠⢞⣴⣿⠟⠁⠀⢀⣴⣏⣉⠓⠺⡇⠀⢸⣿⣷⣦⡄⠀⡸⠃
⠀⠀⠀⠀⠀⠀⢰⢃⣾⡿⠃⠀⠀⣴⠿⢤⣄⣈⠉⠓⢷⠀⠘⣿⣿⣿⣿⠞⠀⠀
⠀⠀⠀⠀⠀⠀⢸⢸⣿⡇⠀⠀⣼⠧⣤⣀⣀⡈⠉⢻⣟⡤⡀⠙⠟⣹⠋⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠘⡄⢻⣧⠀⠀⣿⡀⠀⠀⠈⠉⠉⣿⡜⠀⠈⠒⠚⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠙⡄⢻⣦⠀⠸⣏⠉⠉⠙⠛⠛⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⢻⣆⠀⠹⣤⠤⠤⠤⠤⣿⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⢻⣧⠀⢻⡄⠀⠀⠀⣻⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⢻⣧⠀⢻⡉⠉⠉⠙⣏⡆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⢻⣧⠈⢷⡤⠤⠶⢿⣴⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢦⢻⣧⠈⣧⣀⣀⣼⣇⡆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⢻⣆⠘⣧⠀⣀⣹⡽⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⢿⣆⠘⣏⠁⣈⣷⠇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠈⣎⢿⡆⠹⡏⢁⣹⡾⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⡠⠔⣉⠠⣬⣑⠢⡀⠀⠀⠀⠘⡜⣿⡀⢻⡉⣈⣧⠇⠀⠀⠀⠀⠀
⠀⠀⠀⡠⢊⣴⠞⠉⢷⣝⢿⣷⣬⡢⣄⠀⠀⢇⢹⣧⠘⣏⣁⣽⡼⢀⠀⠀⠀⠀
⠀⢀⠊⠰⣿⡁⠀⡴⠋⠙⣶⣝⠻⣿⣮⣑⢄⣸⢸⣿⠀⣿⣡⢼⢇⣶⣍⡢⣄⠀
⠀⣀⠇⣀⡀⠉⠛⠦⣤⣞⠀⣸⠛⢳⠾⠿⣧⠉⣼⣿⠀⣿⢤⡾⠘⠛⣛⣡⣎⢢
⢎⣀⠘⠛⠿⢷⣦⣄⡠⢭⣙⡛⠲⠾⠖⠚⣁⣼⣿⢏⣼⣧⠞⣡⣿⣿⣿⣿⠟⡸
⠀⠀⠈⠉⠒⠒⠠⠬⠭⠅⢀⣉⣉⣙⣛⣛⣛⣉⠀⠬⠭⠤⠬⠭⠭⠭⠍⠒⠉⠀

COBRA
echo -e "${NC}"
echo -e "  ${BOLD}Cobra NixOS Installer${NC}"
echo -e "  ${DIM}Niri + macOS style + Btrfs + Limine${NC}"
echo -e "  ${DIM}github.com/rayone121/cobra-nix-config${NC}"
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""

# ============================================================
#  Step 1: Check environment
# ============================================================
[[ $EUID -eq 0 ]] || err "Run this as root: sudo bash install.sh"

command -v nix >/dev/null 2>&1 || err "Nix not found. Are you booted into the NixOS installer ISO?"
command -v git >/dev/null 2>&1 || { info "Installing git..."; nix-env -iA nixos.git; }

# Install fzf for interactive selection
if ! command -v fzf >/dev/null 2>&1; then
    info "Installing fzf for interactive menus..."
    nix-env -iA nixos.fzf
fi

# ============================================================
#  Step 2: Username
# ============================================================
echo -e "  ${BOLD}1. User Setup${NC}"
echo ""
read -rp "$(echo -e "  ${CYAN}Username: ${NC}")" USERNAME
[[ -n "$USERNAME" ]] || err "Username cannot be empty."
[[ "$USERNAME" =~ ^[a-z_][a-z0-9_-]*$ ]] || err "Invalid username. Use lowercase letters, numbers, hyphens, underscores."

# ============================================================
#  Step 3: Hostname
# ============================================================
echo ""
read -rp "$(echo -e "  ${CYAN}Hostname ${DIM}[cobra]${NC}${CYAN}: ${NC}")" HOSTNAME
HOSTNAME="${HOSTNAME:-cobra}"
[[ "$HOSTNAME" =~ ^[a-zA-Z0-9-]+$ ]] || err "Invalid hostname."

# ============================================================
#  Step 4: Timezone (fzf picker)
# ============================================================
echo ""
echo -e "  ${BOLD}2. Timezone${NC}"
echo ""

# Build timezone list from /usr/share/zoneinfo
if [[ -d /usr/share/zoneinfo ]]; then
    TIMEZONE=$(find /usr/share/zoneinfo -type f ! -path '*/posix/*' ! -path '*/right/*' ! -name '*.tab' ! -name 'posixrules' ! -name 'localtime' \
        | sed 's|/usr/share/zoneinfo/||' \
        | sort \
        | fzf --height=15 --reverse --prompt="  Timezone > " --header="  Type to search, Enter to select" --query="America/")
elif [[ -d /etc/zoneinfo ]]; then
    TIMEZONE=$(find /etc/zoneinfo -type f \
        | sed 's|/etc/zoneinfo/||' \
        | sort \
        | fzf --height=15 --reverse --prompt="  Timezone > " --header="  Type to search, Enter to select" --query="America/")
else
    # Fallback: common timezones
    TIMEZONE=$(printf '%s\n' \
        "America/New_York" "America/Chicago" "America/Denver" "America/Los_Angeles" \
        "America/Toronto" "America/Vancouver" "America/Sao_Paulo" "America/Argentina/Buenos_Aires" \
        "Europe/London" "Europe/Paris" "Europe/Berlin" "Europe/Amsterdam" "Europe/Rome" \
        "Europe/Madrid" "Europe/Stockholm" "Europe/Warsaw" "Europe/Bucharest" "Europe/Moscow" \
        "Europe/Istanbul" "Europe/Helsinki" "Europe/Athens" "Europe/Zurich" "Europe/Vienna" \
        "Asia/Tokyo" "Asia/Shanghai" "Asia/Kolkata" "Asia/Singapore" "Asia/Seoul" \
        "Asia/Dubai" "Asia/Hong_Kong" "Asia/Bangkok" "Asia/Jakarta" \
        "Australia/Sydney" "Australia/Melbourne" "Australia/Perth" \
        "Pacific/Auckland" "Pacific/Honolulu" \
        "Africa/Cairo" "Africa/Johannesburg" "Africa/Lagos" \
        | fzf --height=15 --reverse --prompt="  Timezone > " --header="  Type to search, Enter to select" --query="America/")
fi

[[ -n "$TIMEZONE" ]] || err "No timezone selected."

# ============================================================
#  Step 5: Disk selection (fzf picker)
# ============================================================
echo ""
echo -e "  ${BOLD}3. Disk Selection${NC}"
echo ""

DISK_LINE=$(lsblk -d -n -o NAME,SIZE,MODEL,TRAN \
    | grep -v "loop\|sr\|ram\|zram" \
    | fzf --height=10 --reverse --prompt="  Disk > " --header="  NAME    SIZE  MODEL                TRAN")

[[ -n "$DISK_LINE" ]] || err "No disk selected."
DISK_NAME=$(echo "$DISK_LINE" | awk '{print $1}')
DISK="/dev/${DISK_NAME}"

[[ -b "$DISK" ]] || err "Disk $DISK does not exist."

DISK_SIZE=$(lsblk -d -n -o SIZE "$DISK" | xargs)
DISK_MODEL=$(lsblk -d -n -o MODEL "$DISK" | xargs)

# ============================================================
#  Summary + Confirm
# ============================================================
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""
echo -e "  ${BOLD}Summary${NC}"
echo ""
echo -e "  User:      ${BOLD}${USERNAME}${NC}"
echo -e "  Host:      ${BOLD}${HOSTNAME}${NC}"
echo -e "  Timezone:  ${BOLD}${TIMEZONE}${NC}"
echo -e "  Disk:      ${BOLD}${DISK}${NC} ${DIM}(${DISK_MODEL} — ${DISK_SIZE})${NC}"
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""
echo -e "  ${RED}${BOLD}WARNING: This will ERASE ALL DATA on ${DISK}${NC}"
echo ""
read -rp "$(echo -e "  ${RED}Type 'yes' to confirm: ${NC}")" CONFIRM
[[ "$CONFIRM" == "yes" ]] || err "Aborted."
echo ""

# ============================================================
#  Step 6: Detect CPU vendor
# ============================================================
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
if [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
    KVM_MODULE="kvm-amd"
    CPU_UCODE="amd"
    ok "Detected AMD CPU"
elif [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
    KVM_MODULE="kvm-intel"
    CPU_UCODE="intel"
    ok "Detected Intel CPU"
else
    KVM_MODULE="kvm-intel"
    CPU_UCODE="intel"
    warn "Unknown CPU vendor ($CPU_VENDOR), defaulting to Intel"
fi

# ============================================================
#  Step 7: Clone config
# ============================================================
info "Cloning config..."
if [[ -d "$CONFIG_DIR" ]]; then
    rm -rf "$CONFIG_DIR"
fi

if git clone "$REPO_URL" "$CONFIG_DIR" 2>/dev/null; then
    ok "Cloned from remote"
elif [[ -f "/root/cobra-nix-config/flake.nix" ]]; then
    cp -r /root/cobra-nix-config "$CONFIG_DIR"
    ok "Copied from /root/cobra-nix-config"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$SCRIPT_DIR/flake.nix" ]]; then
        cp -r "$SCRIPT_DIR" "$CONFIG_DIR"
        ok "Copied from script directory"
    else
        err "Cannot find config repo. Clone it manually to $CONFIG_DIR"
    fi
fi

# ============================================================
#  Step 8: Patch config with user details
# ============================================================
info "Personalizing config for ${BOLD}${USERNAME}@${HOSTNAME}${NC}..."

sed -i "s|device = \"/dev/nvme0n1\";|device = \"${DISK}\";|" "$CONFIG_DIR/hosts/cobra/disk.nix"

USERNAME_CAP="$(echo "${USERNAME:0:1}" | tr '[:lower:]' '[:upper:]')${USERNAME:1}"
find "$CONFIG_DIR" -name '*.nix' -exec sed -i "s/INSTALLER_USERNAME/${USERNAME}/g" {} +
find "$CONFIG_DIR" -name '*.nix' -exec sed -i "s/INSTALLER_DISPLAYNAME/${USERNAME_CAP}/g" {} +
find "$CONFIG_DIR" -name '*.nix' -exec sed -i "s/INSTALLER_HOSTNAME/${HOSTNAME}/g" {} +
find "$CONFIG_DIR" -name '*.nix' -exec sed -i "s|INSTALLER_TIMEZONE|${TIMEZONE}|g" {} +

ok "Config patched"

# ============================================================
#  Step 9: Run disko (partition + format + mount)
# ============================================================
info "Running disko — partitioning and formatting ${DISK}..."
nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko "$CONFIG_DIR/hosts/cobra/disk.nix"
ok "Disko complete — mounted at /mnt"

# ============================================================
#  Step 10: Generate hardware config
# ============================================================
info "Generating hardware configuration..."
nixos-generate-config --no-filesystems --root "$INSTALL_DIR" --dir /tmp/hw-config

HW_CONFIG="/tmp/hw-config/hardware-configuration.nix"

if [[ "$CPU_UCODE" == "amd" ]]; then
    sed -i 's/kvm-intel/kvm-amd/' "$HW_CONFIG"
    sed -i 's/hardware\.cpu\.intel/hardware.cpu.amd/' "$HW_CONFIG"
fi

cp "$HW_CONFIG" "$CONFIG_DIR/hosts/cobra/hardware-configuration.nix"

if ! grep -q "hardware.graphics.enable" "$CONFIG_DIR/hosts/cobra/hardware-configuration.nix"; then
    sed -i '/^}$/i\  hardware.graphics.enable = true;' "$CONFIG_DIR/hosts/cobra/hardware-configuration.nix"
fi

ok "Hardware config generated"

# ============================================================
#  Step 11: Copy config to target (user home, not /etc/nixos)
# ============================================================
USER_CONFIG_DIR="${INSTALL_DIR}/home/${USERNAME}/.config/nixos"
info "Copying config to ${USER_CONFIG_DIR}..."
mkdir -p "${USER_CONFIG_DIR}"
cp -r "$CONFIG_DIR"/. "${USER_CONFIG_DIR}/"

# Initialize git so flake can find files
git -C "${USER_CONFIG_DIR}" init -q
git -C "${USER_CONFIG_DIR}" add -A
git -C "${USER_CONFIG_DIR}" commit -q -m "Initial config"

# Set ownership (will be applied after install via nixos-enter)
ok "Config installed to ~/.config/nixos"

# ============================================================
#  Step 12: Install NixOS
# ============================================================
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""
info "Installing NixOS (this will take a while)..."
echo ""
nixos-install --flake "${USER_CONFIG_DIR}#${HOSTNAME}" --no-root-passwd

# ============================================================
#  Step 13: Set user password
# ============================================================
echo ""
info "Set password for user '${USERNAME}':"
nixos-enter --root "$INSTALL_DIR" -- passwd "$USERNAME"

# Fix ownership of config dir
nixos-enter --root "$INSTALL_DIR" -- chown -R "$USERNAME":"users" "/home/${USERNAME}/.config/nixos"

# ============================================================
#  Done!
# ============================================================
clear
echo -e "${GREEN}"
cat << 'COBRA'

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢔⣫⣭⣭⣒⣒⠦⢤⣀⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣵⣿⠿⠋⠀⠀⠉⠙⠓⣶⣬⣙⠲⢄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠟⠁⠀⢀⡴⠶⣤⡀⠀⢈⠑⠊⠿⡆⠑⣄⠀
⠀⠀⠀⠀⠀⠀⠀⢠⢞⣴⣿⠟⠁⠀⢀⣴⣏⣉⠓⠺⡇⠀⢸⣿⣷⣦⡄⠀⡸⠃
⠀⠀⠀⠀⠀⠀⢰⢃⣾⡿⠃⠀⠀⣴⠿⢤⣄⣈⠉⠓⢷⠀⠘⣿⣿⣿⣿⠞⠀⠀
⠀⠀⠀⠀⠀⠀⢸⢸⣿⡇⠀⠀⣼⠧⣤⣀⣀⡈⠉⢻⣟⡤⡀⠙⠟⣹⠋⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠘⡄⢻⣧⠀⠀⣿⡀⠀⠀⠈⠉⠉⣿⡜⠀⠈⠒⠚⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠙⡄⢻⣦⠀⠸⣏⠉⠉⠙⠛⠛⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⢻⣆⠀⠹⣤⠤⠤⠤⠤⣿⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⢻⣧⠀⢻⡄⠀⠀⠀⣻⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⢻⣧⠀⢻⡉⠉⠉⠙⣏⡆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⢻⣧⠈⢷⡤⠤⠶⢿⣴⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢦⢻⣧⠈⣧⣀⣀⣼⣇⡆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⢻⣆⠘⣧⠀⣀⣹⡽⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⢿⣆⠘⣏⠁⣈⣷⠇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠈⣎⢿⡆⠹⡏⢁⣹⡾⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⡠⠔⣉⠠⣬⣑⠢⡀⠀⠀⠀⠘⡜⣿⡀⢻⡉⣈⣧⠇⠀⠀⠀⠀⠀
⠀⠀⠀⡠⢊⣴⠞⠉⢷⣝⢿⣷⣬⡢⣄⠀⠀⢇⢹⣧⠘⣏⣁⣽⡼⢀⠀⠀⠀⠀
⠀⢀⠊⠰⣿⡁⠀⡴⠋⠙⣶⣝⠻⣿⣮⣑⢄⣸⢸⣿⠀⣿⣡⢼⢇⣶⣍⡢⣄⠀
⠀⣀⠇⣀⡀⠉⠛⠦⣤⣞⠀⣸⠛⢳⠾⠿⣧⠉⣼⣿⠀⣿⢤⡾⠘⠛⣛⣡⣎⢢
⢎⣀⠘⠛⠿⢷⣦⣄⡠⢭⣙⡛⠲⠾⠖⠚⣁⣼⣿⢏⣼⣧⠞⣡⣿⣿⣿⣿⠟⡸
⠀⠀⠈⠉⠒⠒⠠⠬⠭⠅⢀⣉⣉⣙⣛⣛⣛⣉⠀⠬⠭⠤⠬⠭⠭⠭⠍⠒⠉⠀

COBRA
echo -e "${NC}"
echo -e "  ${GREEN}${BOLD}Installation complete!${NC}"
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""
echo -e "  User:      ${BOLD}${USERNAME}${NC}"
echo -e "  Host:      ${BOLD}${HOSTNAME}${NC}"
echo -e "  Timezone:  ${BOLD}${TIMEZONE}${NC}"
echo -e "  Disk:      ${BOLD}${DISK}${NC} ${DIM}(${DISK_MODEL} — ${DISK_SIZE})${NC}"
echo -e "  CPU:       ${BOLD}${CPU_UCODE}${NC}"
echo -e "  FS:        ${BOLD}btrfs${NC} ${DIM}(@, @home, @nix, @log, @snapshots)${NC}"
echo -e "  Boot:      ${BOLD}Limine${NC} ${DIM}(Catppuccin Mocha)${NC}"
echo -e "  Desktop:   ${BOLD}Niri${NC} ${DIM}(macOS-style)${NC}"
echo -e "  Config:    ${BOLD}~/.config/nixos${NC}"
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""
echo -e "  Run ${CYAN}${BOLD}reboot${NC} to start your new system."
echo ""
