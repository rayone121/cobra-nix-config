#!/usr/bin/env bash
# ============================================================
#  Cobra NixOS Installer — raymond@cobra
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
echo -e "  ${DIM}Hyprland + macOS style + Btrfs + Limine${NC}"
echo -e "  ${DIM}github.com/rayone121/cobra-nix-config${NC}"
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""

# ============================================================
#  Check environment
# ============================================================
[[ $EUID -eq 0 ]] || err "Run this as root: sudo bash install.sh"
command -v nix >/dev/null 2>&1 || err "Nix not found. Are you booted into the NixOS installer ISO?"
command -v git >/dev/null 2>&1 || { info "Installing git..."; nix-env -iA nixos.git; }

# ============================================================
#  Disk selection
# ============================================================
echo -e "  ${BOLD}Select disk${NC}"
echo ""

mapfile -t DISK_LINES < <(lsblk -d -n -o NAME,SIZE,MODEL,TRAN | grep -v "loop\|sr\|ram\|zram")

if [[ ${#DISK_LINES[@]} -eq 0 ]]; then
    err "No disks found."
fi

echo -e "  ${DIM}  #  NAME        SIZE   MODEL                     TRAN${NC}"
for i in "${!DISK_LINES[@]}"; do
    printf "  ${DIM}%2d)${NC} %s\n" "$((i + 1))" "${DISK_LINES[$i]}"
done
echo ""

read -rp "$(echo -e "  ${CYAN}Select disk [1]: ${NC}")" DISK_CHOICE
DISK_CHOICE="${DISK_CHOICE:-1}"

if ! [[ "$DISK_CHOICE" =~ ^[0-9]+$ ]] || (( DISK_CHOICE < 1 || DISK_CHOICE > ${#DISK_LINES[@]} )); then
    err "Invalid selection."
fi

DISK_NAME=$(echo "${DISK_LINES[$((DISK_CHOICE - 1))]}" | awk '{print $1}')
DISK="/dev/${DISK_NAME}"

[[ -b "$DISK" ]] || err "Disk $DISK does not exist."

DISK_SIZE=$(lsblk -d -n -o SIZE "$DISK" | xargs)
DISK_MODEL=$(lsblk -d -n -o MODEL "$DISK" | xargs)

# ============================================================
#  Confirm
# ============================================================
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""
echo -e "  User:      ${BOLD}raymond${NC}"
echo -e "  Host:      ${BOLD}cobra${NC}"
echo -e "  Timezone:  ${BOLD}Europe/Bucharest${NC}"
echo -e "  Disk:      ${BOLD}${DISK}${NC} ${DIM}(${DISK_MODEL} — ${DISK_SIZE})${NC}"
echo ""
echo -e "  ${RED}${BOLD}WARNING: This will ERASE ALL DATA on ${DISK}${NC}"
echo ""
read -rp "$(echo -e "  ${RED}Type 'yes' to confirm: ${NC}")" CONFIRM
[[ "$CONFIRM" == "yes" ]] || err "Aborted."
echo ""

# ============================================================
#  Detect CPU
# ============================================================
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
if [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
    CPU_UCODE="amd"
    ok "Detected AMD CPU"
elif [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
    CPU_UCODE="intel"
    ok "Detected Intel CPU"
else
    CPU_UCODE="intel"
    warn "Unknown CPU vendor ($CPU_VENDOR), defaulting to Intel"
fi

# ============================================================
#  Clone config
# ============================================================
info "Cloning config..."
[[ -d "$CONFIG_DIR" ]] && rm -rf "$CONFIG_DIR"

if git clone "$REPO_URL" "$CONFIG_DIR" 2>/dev/null; then
    ok "Cloned from remote"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$SCRIPT_DIR/flake.nix" ]]; then
        cp -r "$SCRIPT_DIR" "$CONFIG_DIR"
        ok "Copied from local directory"
    else
        err "Cannot find config repo. Clone it manually to $CONFIG_DIR"
    fi
fi

# ============================================================
#  Patch disk device
# ============================================================
sed -i "s|device = \"/dev/nvme0n1\";|device = \"${DISK}\";|" "$CONFIG_DIR/hosts/cobra/disk.nix"
ok "Disk set to ${DISK}"

# ============================================================
#  Run disko
# ============================================================
info "Running disko — partitioning and formatting ${DISK}..."
nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko "$CONFIG_DIR/hosts/cobra/disk.nix"
ok "Disko complete — mounted at /mnt"

# ============================================================
#  Generate hardware config
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
#  Copy config to target
# ============================================================
USER_CONFIG_DIR="${INSTALL_DIR}/home/raymond/.config/nixos"
info "Copying config to ~/.config/nixos..."
mkdir -p "${USER_CONFIG_DIR}"
cp -r "$CONFIG_DIR"/. "${USER_CONFIG_DIR}/"

git -C "${USER_CONFIG_DIR}" init -q
git -C "${USER_CONFIG_DIR}" add -A
git -C "${USER_CONFIG_DIR}" add -f hosts/cobra/hardware-configuration.nix
git -C "${USER_CONFIG_DIR}" -c user.name="HEAPTRASH" -c user.email="raymond.enescu@gmail.com" commit -q -m "Initial config"

ok "Config installed"

# ============================================================
#  Stow dotfiles (manual symlinks — stow not on live ISO)
# ============================================================
info "Linking dotfiles..."
DOTFILES_DIR="${USER_CONFIG_DIR}/dotfiles"
HOME_DIR="${INSTALL_DIR}/home/raymond"
mkdir -p "${HOME_DIR}/.config" "${HOME_DIR}/.local/bin"
for pkg in hyprland waybar kitty dunst fuzzel matugen oh-my-posh; do
    if [[ -d "${DOTFILES_DIR}/${pkg}/.config" ]]; then
        cp -rs "${DOTFILES_DIR}/${pkg}/.config/"* "${HOME_DIR}/.config/"
    fi
done
# Scripts
if [[ -d "${DOTFILES_DIR}/scripts/.local/bin" ]]; then
    cp -rs "${DOTFILES_DIR}/scripts/.local/bin/"* "${HOME_DIR}/.local/bin/"
fi
ok "Dotfiles linked"

# ============================================================
#  Install NixOS
# ============================================================
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""
info "Installing NixOS (this will take a while)..."
echo ""
nixos-install --flake "${USER_CONFIG_DIR}#cobra" --no-root-passwd

# ============================================================
#  Set user password
# ============================================================
echo ""
info "Set password for user 'raymond':"
nixos-enter --root "$INSTALL_DIR" -- passwd raymond

# Fix ownership
nixos-enter --root "$INSTALL_DIR" -- chown -R raymond:users /home/raymond/.config/nixos

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
echo -e "  User:      ${BOLD}raymond${NC}"
echo -e "  Host:      ${BOLD}cobra${NC}"
echo -e "  Timezone:  ${BOLD}Europe/Bucharest${NC}"
echo -e "  Disk:      ${BOLD}${DISK}${NC} ${DIM}(${DISK_MODEL} — ${DISK_SIZE})${NC}"
echo -e "  CPU:       ${BOLD}${CPU_UCODE}${NC}"
echo -e "  FS:        ${BOLD}btrfs${NC} ${DIM}(@, @home, @nix, @log, @snapshots)${NC}"
echo -e "  Boot:      ${BOLD}Limine${NC} ${DIM}(Catppuccin Mocha)${NC}"
echo -e "  Desktop:   ${BOLD}Hyprland${NC} ${DIM}(macOS-style)${NC}"
echo -e "  Config:    ${BOLD}~/.config/nixos${NC}"
echo ""
echo -e "  ${DIM}────────────────────────────────────${NC}"
echo ""
echo -e "  Run ${CYAN}${BOLD}reboot${NC} to start your new system."
echo ""
