#!/usr/bin/env bash
# Shared utilities for install scripts
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}[*]${NC} $1"; }
ok()    { echo -e "${GREEN}[+]${NC} $1"; }
err()   { echo -e "${RED}[!]${NC} $1"; exit 1; }
warn()  { echo -e "${RED}[!]${NC} $1"; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NIX="nix --extra-experimental-features nix-command"

[[ $EUID -eq 0 ]] || err "Run as root: sudo bash $0"
