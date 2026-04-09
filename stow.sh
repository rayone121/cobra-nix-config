#!/usr/bin/env bash
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles" && pwd)"
for pkg in niri waybar kitty dunst fuzzel swaylock matugen scripts; do
    echo "Stowing $pkg..."
    stow -d "$DOTFILES" -t "$HOME" --restow "$pkg"
done
echo "Done!"
