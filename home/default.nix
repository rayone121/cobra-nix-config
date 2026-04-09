{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./plasma.nix
  ];

  home.username = "raymond";
  home.homeDirectory = "/home/raymond";

  # ---------- Kitty Terminal ----------
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.92";
      window_padding_width = 12;
      confirm_os_window_close = 0;
      hide_window_decorations = "yes";
      background = "#1e1e1e";
      foreground = "#e0e0e0";
      cursor = "#ffffff";
      selection_background = "#3a3a3a";
      selection_foreground = "#ffffff";
    };
  };

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
      name = "HEAPTRASH";
      email = "raymond.enescu@gmail.com";
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
    # Wayland utilities
    libnotify
    wl-clipboard
    grim
    slurp
    pamixer
    pulsemixer

    # TUI tools
    bluetuith

    # Misc CLI
    ripgrep
    fd
    jq
    tree
    btop
    fastfetch
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
