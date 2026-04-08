{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./niri.nix
    ./waybar.nix
    ./theme.nix
  ];

  home.username = "INSTALLER_USERNAME";
  home.homeDirectory = "/home/INSTALLER_USERNAME";

  # ---------- CLI Tools ----------
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      icons.theme = "fancy";
      date = "relative";
      sorting.dir-grouping = "first";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "INSTALLER_GIT_NAME";
    userEmail = "INSTALLER_GIT_EMAIL";
  };

  # ---------- Packages ----------
  home.packages = with pkgs; [
    # Wayland / Niri utilities
    libnotify
    swww
    wl-clipboard
    grim
    slurp
    pamixer
    pavucontrol

    # App launcher (Spotlight-like)
    fuzzel

    # Notifications
    dunst

    # Terminal
    kitty

    # File manager
    nautilus

    # Theming
    matugen

    # Misc CLI
    ripgrep
    fd
    jq
    tree
    btop
    fastfetch
  ];

  # ---------- Scripts ----------
  home.file.".local/bin/wall" = {
    source = ../dotfiles/scripts/wall;
    executable = true;
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
