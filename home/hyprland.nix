{ config, pkgs, lib, ... }:

{
  xdg.configFile."hypr/hyprland.conf".source = ../dotfiles/hyprland/hyprland.conf;

  # hyprscrolling plugin is at 0.53.0 but Hyprland is 0.54.3 — ABI mismatch.
  # All official hyprland-plugins are stuck at 0.53.0 in nixpkgs.
  # Uncomment when nixpkgs updates the plugin:
  # xdg.configFile."hypr/plugins.conf".text = ''
  #   plugin = ${pkgs.hyprlandPlugins.hyprscrolling}/lib/libhyprscrolling.so
  # '';
}
