#!/usr/bin/env bash
# Stow all dotfiles — removes conflicting default configs first
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles" && pwd)"

PACKAGES=(niri waybar kitty dunst fuzzel swaylock matugen scripts cobra)

# Remove default configs that apps may have created
for pkg in "${PACKAGES[@]}"; do
    if [[ -d "$DOTFILES/$pkg/.config" ]]; then
        for dir in "$DOTFILES/$pkg/.config/"*/; do
            target="$HOME/.config/$(basename "$dir")"
            if [[ -d "$target" && ! -L "$target" ]]; then
                echo "Removing default config: $target"
                rm -rf "$target"
            fi
        done
    fi
done

for pkg in "${PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    stow -d "$DOTFILES" -t "$HOME" --restow "$pkg"
done
echo "Done!"
