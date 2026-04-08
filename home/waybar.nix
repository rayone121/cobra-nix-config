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
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];

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
          on-scroll-up = "pamixer -i 2";
          on-scroll-down = "pamixer -d 2";
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀  {ipaddr}";
          format-disconnected = "󰖪  offline";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
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

    style = ''
      /* ===== Global ===== */
      * {
        font-family: "Inter", "JetBrainsMono Nerd Font", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      /* ===== TOP BAR (Menu Bar) ===== */
      window#waybar.top-bar,
      #waybar.top {
        background: rgba(30, 30, 30, 0.85);
        color: #ffffffe6;
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      #custom-apple {
        font-size: 16px;
        padding: 0 12px 0 10px;
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 6px;
        color: #ffffff88;
        border: none;
        border-radius: 8px;
        background: transparent;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: #ffffff;
        background: rgba(255, 255, 255, 0.15);
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
      }

      #clock {
        font-weight: 500;
        padding: 0 12px;
      }

      #pulseaudio,
      #network,
      #battery,
      #tray {
        padding: 0 10px;
      }

      #battery.warning {
        color: #ffcc00;
      }

      #battery.critical {
        color: #ff3b30;
      }

      /* ===== BOTTOM BAR (Dock) ===== */
      window#waybar.bottom-dock,
      #waybar.bottom {
        background: rgba(30, 30, 30, 0.75);
        border-radius: 16px;
        border: 1px solid rgba(255, 255, 255, 0.12);
        padding: 4px 8px;
      }

      #taskbar {
        padding: 0;
      }

      #taskbar button {
        padding: 4px 8px;
        margin: 0 2px;
        border-radius: 12px;
        background: transparent;
        border: none;
        transition: all 0.2s ease;
      }

      #taskbar button:hover {
        background: rgba(255, 255, 255, 0.12);
      }

      #taskbar button.active {
        background: rgba(255, 255, 255, 0.18);
      }

      /* Active indicator dot under dock icon */
      #taskbar button.active::after {
        content: "";
        display: block;
        width: 4px;
        height: 4px;
        border-radius: 50%;
        background: #ffffff;
        margin: 2px auto 0;
      }

      tooltip {
        background: rgba(30, 30, 30, 0.92);
        border: 1px solid rgba(255, 255, 255, 0.12);
        border-radius: 8px;
        color: #ffffffee;
      }
    '';
  };
}
