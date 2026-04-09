{ config, pkgs, lib, userConfig, ... }:

{
  programs.plasma = {
    enable = true;

    # ---------- Single top panel (dwm-style) ----------
    panels = [
      {
        location = "top";
        height = 28;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.taskmanager"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    # ---------- KWin ----------
    kwin = {
      borderlessMaximizedWindows = true;
      virtualDesktops = {
        number = 9;
        rows = 1;
      };
    };

    # ---------- Shortcuts ----------
    shortcuts = {
      "kwin"."Window Close" = "Meta+Q";
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
    };

    # ---------- Polonium + KWin config ----------
    configFile = {
      "kwinrc"."Plugins".poloniumEnabled = true;
      "kwinrc"."Script-polonium" = {
        Borders = 1;
        GapSize = 8;
      };
    };
  };

  home.packages = with pkgs; [
    polonium
  ];
}
