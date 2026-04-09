{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./zsh.nix
  ];

  home.username = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";

  # ---------- Kitty ----------
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

  programs.firefox = {
    enable = true;
    profiles.default.isDefault = true;
  };

  # ---------- Packages ----------
  home.packages = with pkgs; [
    claude-code
    opencode
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
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
