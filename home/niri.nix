{ config, pkgs, lib, ... }:

{
  wayland.windowManager.niri = {
    enable = true;
    settings = {
      # ---------- Startup ----------
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "dunst" ]; }
        { command = [ "dbus-update-activation-environment" "--systemd" "--all" ]; }
      ];

      # ---------- Input ----------
      input = {
        keyboard = {
          xkb = {
            layout = "us";
          };
        };
        mouse = {
          accel-speed = 0.0;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true;
        };
        focus-follows-mouse = {
          enable = true;
        };
      };

      # ---------- Output ----------
      outputs."*" = {
        scale = 1.0;
      };

      # ---------- Layout ----------
      layout = {
        gaps = 8;
        struts = { };
        focus-ring = {
          width = 2;
          active.color = "#ffffffaa";
          inactive.color = "#ffffff22";
        };
        border = {
          enable = false;
        };
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width = {
          proportion = 1.0 / 2.0;
        };
      };

      # ---------- Window decorations ----------
      prefer-no-csd = true;

      # ---------- Environment ----------
      environment = {
        XCURSOR_SIZE = "24";
        QT_QPA_PLATFORM = "wayland;xcb";
      };

      # ---------- Window rules ----------
      window-rules = [
        {
          geometry-corner-radius =
            let r = 12.0; in
            { bottom-left = r; bottom-right = r; top-left = r; top-right = r; };
          clip-to-geometry = true;
        }
      ];

      # ---------- Keybindings ----------
      binds = let
        spawn = cmd: { action.spawn = cmd; };
      in {
        # Core
        "Mod+Return"        = spawn [ "kitty" ];
        "Mod+Space"         = spawn [ "fuzzel" ];
        "Mod+Q"             = { action.close-window = []; };
        "Mod+E"             = spawn [ "nautilus" ];
        "Mod+Shift+M"       = { action.quit = { skip-confirmation = true; }; };
        "Mod+F"             = { action.maximize-column = []; };
        "Mod+V"             = { action.toggle-window-floating = []; };
        "Mod+Shift+F"       = { action.fullscreen-window = []; };

        # Focus (vim)
        "Mod+H"             = { action.focus-column-left = []; };
        "Mod+L"             = { action.focus-column-right = []; };
        "Mod+K"             = { action.focus-workspace-up = []; };
        "Mod+J"             = { action.focus-workspace-down = []; };

        # Focus (arrows)
        "Mod+Left"          = { action.focus-column-left = []; };
        "Mod+Right"         = { action.focus-column-right = []; };
        "Mod+Up"            = { action.focus-workspace-up = []; };
        "Mod+Down"          = { action.focus-workspace-down = []; };

        # Move windows (vim)
        "Mod+Shift+H"       = { action.move-column-left = []; };
        "Mod+Shift+L"       = { action.move-column-right = []; };
        "Mod+Shift+K"       = { action.move-window-up = []; };
        "Mod+Shift+J"       = { action.move-window-down = []; };

        # Move windows (arrows)
        "Mod+Shift+Left"    = { action.move-column-left = []; };
        "Mod+Shift+Right"   = { action.move-column-right = []; };
        "Mod+Shift+Up"      = { action.move-window-up = []; };
        "Mod+Shift+Down"    = { action.move-window-down = []; };

        # Resize
        "Mod+Ctrl+H"        = { action.set-column-width = "-10%"; };
        "Mod+Ctrl+L"        = { action.set-column-width = "+10%"; };

        # Column width presets
        "Mod+R"             = { action.switch-preset-column-width = []; };

        # Workspaces
        "Mod+1"             = { action.focus-workspace = 1; };
        "Mod+2"             = { action.focus-workspace = 2; };
        "Mod+3"             = { action.focus-workspace = 3; };
        "Mod+4"             = { action.focus-workspace = 4; };
        "Mod+5"             = { action.focus-workspace = 5; };
        "Mod+6"             = { action.focus-workspace = 6; };
        "Mod+7"             = { action.focus-workspace = 7; };
        "Mod+8"             = { action.focus-workspace = 8; };
        "Mod+9"             = { action.focus-workspace = 9; };

        # Move window to workspace
        "Mod+Shift+1"       = { action.move-column-to-workspace = 1; };
        "Mod+Shift+2"       = { action.move-column-to-workspace = 2; };
        "Mod+Shift+3"       = { action.move-column-to-workspace = 3; };
        "Mod+Shift+4"       = { action.move-column-to-workspace = 4; };
        "Mod+Shift+5"       = { action.move-column-to-workspace = 5; };
        "Mod+Shift+6"       = { action.move-column-to-workspace = 6; };
        "Mod+Shift+7"       = { action.move-column-to-workspace = 7; };
        "Mod+Shift+8"       = { action.move-column-to-workspace = 8; };
        "Mod+Shift+9"       = { action.move-column-to-workspace = 9; };

        # Consume / expel windows
        "Mod+BracketLeft"   = { action.consume-window-into-column = []; };
        "Mod+BracketRight"  = { action.expel-window-from-column = []; };

        # Screenshot
        "Print"             = { action.screenshot = []; };
        "Shift+Print"       = { action.screenshot-screen = []; };

        # Media / brightness
        "XF86AudioRaiseVolume"  = { action.spawn = [ "pamixer" "-i" "5" ]; allow-when-locked = true; };
        "XF86AudioLowerVolume"  = { action.spawn = [ "pamixer" "-d" "5" ]; allow-when-locked = true; };
        "XF86AudioMute"         = { action.spawn = [ "pamixer" "-t" ]; allow-when-locked = true; };
        "XF86MonBrightnessUp"   = { action.spawn = [ "brightnessctl" "set" "+5%" ]; allow-when-locked = true; };
        "XF86MonBrightnessDown" = { action.spawn = [ "brightnessctl" "set" "5%-" ]; allow-when-locked = true; };
      };
    };
  };
}
