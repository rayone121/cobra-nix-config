# Cobra NixOS Config

Minimal KDE Plasma 6 NixOS configuration with gaming, dev tools, and NVIDIA support.

## What's Inside

- **Desktop**: KDE Plasma 6 (Wayland, SDDM)
- **Shell**: Zsh + zinit + oh-my-posh + bat + lsd + zoxide + fzf
- **Terminal**: Kitty
- **Browser**: Firefox
- **Gaming**: Steam, Gamescope, GameMode, MangoHud, Lutris, Heroic, Wine, ProtonPlus
- **NVIDIA**: Open kernel modules + CUDA
- **VMs**: libvirtd + virt-manager
- **Dev**: claude-code, opencode, gh, direnv
- **Media**: mpv
- **Filesystem**: Btrfs with subvolumes (@, @home, @nix, @log, @snapshots)
- **Boot**: systemd-boot

## Install

### 1. Fork this repo and edit `config.nix`

```nix
{
  hostname = "mypc";
  username = "myuser";
  timezone = "America/New_York";
  disk = "/dev/nvme0n1";       # run lsblk to find yours
  gitName = "My Name";
  gitEmail = "me@example.com";
}
```

### 2. Boot the NixOS ISO and clone your fork

```bash
sudo -i
nix-env -iA nixos.git
git clone https://github.com/YOUR_USER/cobra-nix-config.git
cd cobra-nix-config
```

### 3. Run the full setup

```bash
sudo bash setup.sh
```

Or run steps individually:

```bash
sudo bash scripts/01-partition.sh   # disko: partition + format + mount
sudo bash scripts/02-hardware.sh    # generate hardware-configuration.nix
sudo bash scripts/03-install.sh     # copy config + nixos-install
sudo bash scripts/04-post-install.sh # set password + fix ownership
reboot
```

## Post-Install

```bash
rebuild    # sudo nixos-rebuild switch --flake ~/.config/nixos#hostname
update     # nix flake update
```

## Structure

```
config.nix                     # <-- edit this (only file you need to change)
flake.nix                      # flake inputs + outputs
setup.sh                       # runs all install scripts
scripts/
  lib.sh                       # shared utilities
  01-partition.sh              # disko partitioning
  02-hardware.sh               # hardware config generation
  03-install.sh                # nixos-install
  04-post-install.sh           # password + ownership
hosts/cobra/
  configuration.nix            # system config (reads config.nix)
  disk.nix                     # btrfs subvolumes (reads config.nix)
  hardware-configuration.nix   # generated at install time
modules/
  nvidia.nix                   # NVIDIA drivers + CUDA
  gaming.nix                   # Steam + gaming stack
home/
  default.nix                  # home-manager (reads config.nix)
  zsh.nix                      # shell config (reads config.nix)
```
