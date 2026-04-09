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

  # ---------- Dunst Notifications ----------
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
      size = "48";
    };
    settings = {
      global = {
        width = 350;
        height = 100;
        offset = "12x12";
        origin = "top-right";
        frame_color = "#ffffff33";
        frame_width = 1;
        corner_radius = 12;
        font = "Inter 11";
        padding = 12;
        horizontal_padding = 16;
        max_icon_size = 48;
        background = "#2d2d2df0";
        foreground = "#ffffffee";
      };
      urgency_low = {
        background = "#2d2d2df0";
        foreground = "#ffffffcc";
        timeout = 5;
      };
      urgency_normal = {
        background = "#2d2d2df0";
        foreground = "#ffffffee";
        timeout = 8;
      };
      urgency_critical = {
        background = "#ff3b30f0";
        foreground = "#ffffffff";
        timeout = 0;
      };
    };
  };

  # ---------- Fuzzel Launcher ----------
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=Inter:size=13
    prompt=
    icon-theme=WhiteSur-dark
    terminal=kitty
    layer=overlay
    lines=8
    width=40
    horizontal-pad=20
    vertical-pad=12
    inner-pad=8

    [colors]
    background=2d2d2dfa
    text=ffffffee
    match=89b4faff
    selection=ffffff22
    selection-text=ffffffee
    border=ffffff33

    [border]
    width=1
    radius=12
  '';
}
