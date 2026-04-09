{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./hyprland.nix
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
    signing.format = null;
    settings.user = {
      name = "INSTALLER_GIT_NAME";
      email = "INSTALLER_GIT_EMAIL";
    };
  };

  # ---------- Firefox ----------
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "browser.toolbars.bookmarks.visibility" = "newtab";
      };
    };
  };

  # ---------- Packages ----------
  home.packages = with pkgs; [
    # Wayland / Niri utilities
    libnotify
    awww
    wl-clipboard
    grim
    slurp
    pamixer
    pulsemixer

    # App launcher
    fuzzel

    # Bar
    waybar

    # Notifications
    dunst

    # Terminal
    kitty

    # File manager
    nautilus

    # TUI tools
    bluetuith

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

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
