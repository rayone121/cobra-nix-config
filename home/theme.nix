{ config, pkgs, lib, ... }:

{
  # ---------- GTK Theme (macOS-like) ----------
  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
    cursorTheme = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
    };
    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 11;
    };
  };

  home.pointerCursor = {
    name = "macOS";
    package = pkgs.apple-cursor;
    size = 24;
    gtk.enable = true;
  };

  # ---------- Matugen (Material You from wallpaper) ----------
  xdg.configFile."matugen/config.toml".source = ../dotfiles/matugen/config.toml;
  xdg.configFile."matugen/templates".source = ../dotfiles/matugen/templates;

  # ---------- Dotfiles ----------
  xdg.configFile."fuzzel/fuzzel.ini".source = ../dotfiles/fuzzel/fuzzel.ini;
  xdg.configFile."dunst/dunstrc".source = ../dotfiles/dunst/dunstrc;
  xdg.configFile."kitty/kitty.conf".source = ../dotfiles/kitty/kitty.conf;

  # Dunst service (just enable, config comes from dotfile)
  services.dunst.enable = true;

  # Kitty (just enable, config comes from dotfile)
  programs.kitty.enable = true;
}
