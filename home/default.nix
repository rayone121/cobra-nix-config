{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./zsh.nix
    ./niri.nix
    ./waybar.nix
    ./theme.nix
  ];

  home.username = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";

  # ---------- Kitty (warm palette) ----------
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

      # Warm color palette
      foreground = "#fce8c3";
      background = "#1c1b19";
      cursor = "#fbb829";
      cursor_text_color = "#1c1b19";
      selection_foreground = "#1c1b19";
      selection_background = "#fce8c3";

      # Normal colors
      color0 = "#1c1b19";
      color1 = "#ef2f27";
      color2 = "#519f50";
      color3 = "#fbb829";
      color4 = "#2c78bf";
      color5 = "#e02c6d";
      color6 = "#0aaeb3";
      color7 = "#baa67f";

      # Bright colors
      color8 = "#918175";
      color9 = "#f75341";
      color10 = "#98bc37";
      color11 = "#fed06e";
      color12 = "#68a8e4";
      color13 = "#ff5c8f";
      color14 = "#2be4d0";
      color15 = "#fce8c3";
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
      name = userConfig.gitName;
      email = userConfig.gitEmail;
    };
  };

  # ---------- Tmux ----------
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = true;
    extraConfig = ''
      set -g renumber-windows on
      set -g set-titles on
      set -g status-position top
      set -g status-style "bg=default,fg=white"
      set -g status-left "#[bold] #S "
      set -g status-right " %H:%M "
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };

  programs.firefox = {
    enable = true;
    profiles.default.isDefault = true;
  };

  # ---------- Packages ----------
  home.packages = with pkgs; [
    claude-code
    opencode
    zed-editor
    ripgrep
    fd
    jq
    tree
    btop
    fastfetch
    pamixer
    pulsemixer
    bluetuith
    wl-clipboard
    fuzzel
    dunst
    swaylock
    swayidle
    grim
    slurp
    lazydocker
    networkmanagerapplet
    libnotify
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
