{ config, lib, pkgs, modulesPath, ... }:

{
  # The installer script will overwrite this file with the real output of
  # `nixos-generate-config --show-hardware-config`.
  #
  # These are safe placeholder defaults. Disko handles all filesystems.

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # change to kvm-amd for AMD
  boot.extraModulePackages = [ ];

  # Filesystems are managed by disko (disk.nix) — do NOT define them here.

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics.enable = true;
}
