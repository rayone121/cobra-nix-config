{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false; # launched by niri spawn-at-startup

    settings = {
      # ==================== TOP BAR (macOS menu bar) ====================
      top-bar = {
        layer = "top";
        position = "top";
        height = 32;
        margin-top = 4;
        margin-left = 8;
        margin-right = 8;
        modules-left = [ "custom/apple" "niri/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "bluetooth" "pulseaudio" "network" "battery" "tray" ];

        "custom/apple" = {
          format = " ";
          tooltip = false;
        };

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        clock = {
          format = "{:%a %b %d  %I:%M %p}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "  muted";
          format-icons = {
            default = [ " " " " " " ];
          };
          on-click = "pamixer -t";
          on-click-right = "kitty --title pulsemixer -e pulsemixer";
          on-scroll-up = "pamixer -i 2";
          on-scroll-down = "pamixer -d 2";
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀  {ipaddr}";
          format-disconnected = "󰖪  offline";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          on-click = "kitty --title nmtui -e nmtui";
        };

        bluetooth = {
          format = "󰂯 {status}";
          format-connected = "󰂱 {device_alias}";
          format-disabled = "󰂲";
          on-click = "kitty --title bluetuith -e bluetuith";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };
      };

      # ==================== BOTTOM BAR (macOS Dock) ====================
      bottom-dock = {
        layer = "top";
        position = "bottom";
        height = 52;
        margin-bottom = 6;
        margin-left = 200;
        margin-right = 200;
        modules-center = [ "wlr/taskbar" ];

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 32;
          icon-theme = "WhiteSur-dark";
          on-click = "activate";
          on-click-middle = "close";
          tooltip-format = "{title}";
        };
      };
    };

    # CSS loaded from dotfile
    style = builtins.readFile ../dotfiles/waybar/style.css;
  };
}
