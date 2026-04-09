#!/usr/bin/env bash
# Stow all dotfiles into ~
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles" && pwd)"

packages=(hyprland waybar kitty dunst fuzzel matugen oh-my-posh scripts)

for pkg in "${packages[@]}"; do
    echo "Stowing $pkg..."
    stow -d "$DOTFILES_DIR" -t "$HOME" --restow "$pkg"
done

echo "Done! All dotfiles stowed."
