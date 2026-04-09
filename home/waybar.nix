{ config, pkgs, lib, userConfig, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        spacing = 0;

        modules-left = [ "niri/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "bluetooth" "network" "pulseaudio" "cpu" "battery" "tray" ];

        "niri/workspaces" = {
          format = "{index}";
          on-click = "activate";
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-disabled = "";
          on-click = "kitty -e bluetuith";
          tooltip-format = "{controller_alias}\t{controller_address}";
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ifname}";
          format-disconnected = "  Disconnected";
          on-click = "kitty -e nmtui";
          tooltip-format = "{ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "kitty -e pulsemixer";
        };

        cpu = {
          format = " {usage}%";
          interval = 5;
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: #1c1b19;
        color: #fce8c3;
        border-bottom: 2px solid #2a2927;
      }

      #workspaces button {
        padding: 0 6px;
        color: #918175;
        background: transparent;
        border: none;
        border-radius: 0;
      }

      #workspaces button.active {
        color: #fbb829;
        font-weight: bold;
      }

      #workspaces button:hover {
        background: #2a2927;
        color: #fce8c3;
      }

      #clock {
        color: #fce8c3;
        font-weight: bold;
      }

      #bluetooth,
      #network,
      #pulseaudio,
      #cpu,
      #battery,
      #tray {
        padding: 0 8px;
        color: #baa67f;
      }

      #bluetooth:hover,
      #network:hover,
      #pulseaudio:hover,
      #cpu:hover,
      #battery:hover {
        color: #fbb829;
      }

      #battery.warning {
        color: #fbb829;
      }

      #battery.critical {
        color: #ef2f27;
      }

      #network.disconnected {
        color: #918175;
      }

      #pulseaudio.muted {
        color: #918175;
      }
    '';
  };
}
