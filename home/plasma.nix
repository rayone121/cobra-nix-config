{ config, pkgs, lib, ... }:

{
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    # ---------- macOS-like workspace ----------
    workspace = {
      theme = "default";
      colorScheme = "BreezeDark";
      cursor = {
        theme = "macOS";
        size = 24;
      };
      iconTheme = "WhiteSur-dark";
      wallpaper = null; # set manually or via wallpaper plugin
    };

    # ---------- Panel (macOS-like top bar) ----------
    panels = [
      {
        location = "top";
        height = 32;
        floating = true;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
        ];
      }
      {
        location = "bottom";
        height = 56;
        floating = true;
        widgets = [
          "org.kde.plasma.icontasks"
        ];
      }
    ];

    # ---------- Shortcuts ----------
    shortcuts = {
      "kwin"."Window Close" = "Meta+Q";
      "kwin"."Toggle Overview" = "Meta+Space";
      "kwin"."Window Fullscreen" = "Meta+F";
      "kwin"."Window Maximize" = "Meta+Shift+F";
      "kwin"."Window Minimize" = "Meta+M";
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Switch to Desktop 5" = "Meta+5";
      "kwin"."Switch to Desktop 6" = "Meta+6";
      "kwin"."Switch to Desktop 7" = "Meta+7";
      "kwin"."Switch to Desktop 8" = "Meta+8";
      "kwin"."Switch to Desktop 9" = "Meta+9";
      "kwin"."Window to Desktop 1" = "Meta+Shift+1";
      "kwin"."Window to Desktop 2" = "Meta+Shift+2";
      "kwin"."Window to Desktop 3" = "Meta+Shift+3";
      "kwin"."Window to Desktop 4" = "Meta+Shift+4";
      "kwin"."Window to Desktop 5" = "Meta+Shift+5";
      "kwin"."Window to Desktop 6" = "Meta+Shift+6";
      "kwin"."Window to Desktop 7" = "Meta+Shift+7";
      "kwin"."Window to Desktop 8" = "Meta+Shift+8";
      "kwin"."Window to Desktop 9" = "Meta+Shift+9";
      "org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Print";
      "org.kde.dolphin.desktop"."_launch" = "Meta+E";
    };

    # ---------- KWin settings ----------
    kwin = {
      borderlessMaximizedWindows = true;
      effects = {
        blur.enable = true;
        translucency.enable = true;
      };
      virtualDesktops = {
        number = 9;
        rows = 3;
      };
    };

    # ---------- Config files ----------
    configFile = {
      # Window decorations
      "kwinrc"."org.kde.kdecoration2" = {
        library = "org.kde.breeze";
        theme = "Breeze";
        ButtonsOnLeft = "XIA";
        ButtonsOnRight = "";
        CloseOnDoubleClickOnMenu = true;
      };
      # Polonium tiling
      "kwinrc"."Plugins" = {
        poloniumEnabled = true;
      };
      "kwinrc"."Script-polonium" = {
        Borders = 1;
        GapSize = 8;
        InsertionPoint = 1;
      };
      # Desktop effects
      "kwinrc"."Effect-overview" = {
        BorderActivate = 9;
      };
    };
  };

  # ---------- Packages ----------
  home.packages = with pkgs; [
    # Polonium tiling
    polonium

    # macOS theming
    whitesur-icon-theme
    whitesur-kde
    apple-cursor

    # KDE extras
    kdePackages.plasma-browser-integration
    plasma-panel-colorizer
  ];

  # ---------- GTK (for non-KDE apps) ----------
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
}
