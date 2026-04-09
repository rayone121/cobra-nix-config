{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ../../modules/nvidia.nix
    ../../modules/gaming.nix
  ] ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  # ---------- Boot ----------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ---------- Networking ----------
  networking.hostName = userConfig.hostname;
  networking.networkmanager.enable = true;

  # ---------- Time / Locale ----------
  time.timeZone = userConfig.timezone;
  i18n.defaultLocale = userConfig.locale;

  # ---------- Nix ----------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---------- Users ----------
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.description;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "libvirtd" "docker" ];
    shell = pkgs.zsh;
  };

  # ---------- Niri (Wayland compositor) ----------
  programs.niri.enable = true;

  # ---------- Greetd (auto-login after LUKS) ----------
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = userConfig.username;
      };
    };
  };

  # Suppress greetd errors on tty
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # ---------- Swaylock PAM ----------
  security.pam.services.swaylock = {};

  # ---------- Audio (PipeWire) ----------
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # ---------- Virtualisation ----------
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.virt-manager.enable = true;

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
    kitty
    mpv
    gh
  ];

  # ---------- XDG Portal (for niri/wayland) ----------
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

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

  # ---------- Firmware ----------
  hardware.enableAllFirmware = true;
  services.fwupd.enable = true;

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
