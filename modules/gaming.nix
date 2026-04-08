{ config, pkgs, lib, ... }:

{
  # ---------- Steam ----------
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # ---------- Gamescope ----------
  programs.gamescope = {
    enable = true;
    env = {
      # Force Wayland backend
      ENABLE_GAMESCOPE_WSI = "1";
    };
  };

  # ---------- GameMode ----------
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
      };
    };
  };

  # ---------- Gaming packages ----------
  environment.systemPackages = with pkgs; [
    # Overlay / HUD
    mangohud
    mangojuice        # GUI for MangoHud config

    # Proton management
    protonup-qt       # GUI to install/manage GE-Proton
    protonplus        # Alternative Proton manager

    # Game launchers
    lutris            # Multi-platform game manager (GOG, Epic, etc.)
    heroic            # Epic / GOG / Amazon launcher

    # Wine
    wineWow64Packages.stable
    winetricks

    # Utilities
    scanmem           # Memory scanner (gameconqueror removed from nixpkgs)
    vulkan-tools      # vulkaninfo, etc.
  ];

  # ---------- Hardware support ----------
  hardware.steam-hardware.enable = true; # udev rules for Steam controllers
}
