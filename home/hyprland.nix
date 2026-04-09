{ config, pkgs, lib, ... }:

{
  xdg.configFile."hypr/hyprland.conf".source = ../dotfiles/hyprland/hyprland.conf;

  home.packages = with pkgs; [
    hyprlandPlugins.hyprscrolling
  ];
}
