{ config, pkgs, lib, ... }:

{
  # ---------- NVIDIA Driver ----------
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Open kernel modules — recommended by NVIDIA for Turing (RTX 2000/Quadro RTX) and newer.
    # Same functionality as proprietary; the closed bits are in userspace/firmware.
    open = true;

    # Use the stable driver branch
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Required for Wayland compositors (niri, Hyprland, sway)
    modesetting.enable = true;

    # Power management — saves power when GPU is idle
    powerManagement.enable = true;

    # nvidia-settings GUI
    nvidiaSettings = true;
  };

  # ---------- OpenGL / Vulkan ----------
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # 32-bit support for Steam/Wine
  };

  # ---------- Environment variables for Wayland + NVIDIA ----------
  environment.sessionVariables = {
    # Force GBM backend for Wayland (required for NVIDIA)
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Cursor fix for NVIDIA on Wayland
    WLR_NO_HARDWARE_CURSORS = "1";

    # Electron / Chromium Wayland flags
    NIXOS_OZONE_WL = "1";
  };

  # ---------- Kernel params ----------
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1" # NVIDIA framebuffer for Wayland — driver 545+
  ];

  # Early KMS for NVIDIA
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
}
