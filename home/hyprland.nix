{ config, pkgs, lib, ... }:

let
  hyprscrolling = pkgs.hyprlandPlugins.hyprscrolling;
in
{
  xdg.configFile."hypr/hyprland.conf".source = ../dotfiles/hyprland/hyprland.conf;

  # Write plugin load file that hyprland.conf sources
  xdg.configFile."hypr/plugins.conf".text = ''
    plugin = ${hyprscrolling}/lib/libhyprscrolling.so
  '';
}
