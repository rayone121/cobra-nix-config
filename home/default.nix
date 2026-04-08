{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./niri.nix
    ./waybar.nix
    ./theme.nix
  ];

  home.username = "raymond";
  home.homeDirectory = "/home/raymond";

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
    # TODO: set your name/email
    # userName = "Raymond";
    # userEmail = "you@example.com";
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

    # Misc CLI
    ripgrep
    fd
    jq
    tree
    btop
    fastfetch
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
