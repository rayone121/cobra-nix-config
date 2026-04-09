{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
    ../../modules/gaming.nix
  ];

  # ---------- Boot (Limine + Catppuccin Mocha) ----------
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 10;
    style = {
      wallpapers = [ ./wallpaper.png ];
      wallpaperStyle = "stretched";
      backdrop = "1e1e2e";
      interface = {
        branding = "  cobra";
        brandingColor = 4;
        helpHidden = true;
      };
      graphicalTerminal = {
        background = "cc1e1e2e";
        foreground = "cdd6f4";
        palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
        brightForeground = "cdd6f4";
        brightBackground = "585b70";
        brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
        margin = 6;
      };
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------- Networking ----------
  networking.hostName = "cobra";
  networking.networkmanager.enable = true;

  # ---------- Time / Locale ----------
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  # ---------- Nix ----------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---------- Users ----------
  users.users.raymond = {
    isNormalUser = true;
    description = "Raymond";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # ---------- Niri ----------
  programs.niri.enable = true;

  # ---------- Display / Login ----------
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # ---------- Audio (PipeWire) ----------
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # ---------- XDG Portal ----------
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # ---------- SSH ----------
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # ---------- Shell ----------
  programs.zsh.enable = true;

  # ---------- System packages ----------
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    unzip
    htop
    killall
    brightnessctl
  ];

  # ---------- Bluetooth ----------
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # ---------- Btrfs maintenance ----------
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # ---------- Zram Swap ----------
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  # ---------- Security ----------
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # ---------- Fonts ----------
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    inter
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  system.stateVersion = "24.11";
}
