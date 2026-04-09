#!/usr/bin/env bash
# Partition and format disk using disko
set -euo pipefail
source "$(dirname "$0")/lib.sh"

DISK=$(nix eval --raw -f "$REPO_DIR/config.nix" disk)
info "Partitioning ${BOLD}${DISK}${NC}..."

echo ""
lsblk -d -o NAME,SIZE,MODEL "$DISK"
echo ""
warn "This will ERASE ALL DATA on ${DISK}"
read -rp "$(echo -e "${RED}Type 'yes' to confirm: ${NC}")" CONFIRM
[[ "$CONFIRM" == "yes" ]] || err "Aborted."

nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- --mode disko "$REPO_DIR/hosts/cobra/disk.nix"

ok "Disk partitioned and mounted at /mnt"
