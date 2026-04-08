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
    protonplus

    # Game launchers
    lutris
    heroic

    # Wine
    wineWow64Packages.stable
    winetricks

    # Utilities
    vulkan-tools
  ];

  # ---------- Hardware support ----------
  hardware.steam-hardware.enable = true; # udev rules for Steam controllers
}
