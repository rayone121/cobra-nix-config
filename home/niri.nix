{ config, pkgs, lib, ... }:

{
  # Niri config is written in KDL — managed via xdg.configFile
  # since there's no native Home Manager module for niri settings.

  xdg.configFile."niri/config.kdl".text = ''
    // ---------- Input ----------
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
            accel-speed 0.3
        }
        mouse {
            accel-speed 0.0
        }
    }

    // ---------- Output ----------
    // Uncomment and adjust for your monitor:
    // output "eDP-1" {
    //     mode "1920x1080@60"
    //     scale 1.0
    // }

    // ---------- Layout (macOS-like spacing) ----------
    layout {
        gaps 8
        center-focused-column "never"

        preset-column-widths {
            proportion 0.5
            proportion 0.667
            proportion 1.0
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            off
        }

        border {
            width 1
            active-color "#ffffff44"
            inactive-color "#ffffff11"
        }
    }

    // ---------- Window appearance ----------
    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"

    window-rule {
        geometry-corner-radius 12 12 12 12
        clip-to-geometry true
    }

    // ---------- Startup ----------
    spawn-at-startup "swww-daemon"
    spawn-at-startup "waybar"
    spawn-at-startup "dunst"
    spawn-at-startup "fuzzel" // preload

    // ---------- Key bindings ----------
    binds {
        // App launchers
        Mod+Space { spawn "fuzzel"; }
        Mod+Return { spawn "kitty"; }
        Mod+E { spawn "nautilus"; }

        // Window management
        Mod+Q { close-window; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+V { center-column; }
        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // Focus (vim keys)
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }

        // Focus (arrow keys)
        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Down { focus-window-down; }
        Mod+Up { focus-window-up; }

        // Move windows (vim keys)
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        // Move windows (arrow keys)
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Down { move-window-down; }
        Mod+Shift+Up { move-window-up; }

        // Resize
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Column width presets
        Mod+R { switch-preset-column-width; }

        // Workspaces
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Scroll through workspaces
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up { focus-workspace-up; }
        Mod+Shift+Page_Down { move-column-to-workspace-down; }
        Mod+Shift+Page_Up { move-column-to-workspace-up; }

        // Screenshot
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // Media keys
        XF86AudioRaiseVolume allow-when-locked=true { spawn "pamixer" "-i" "5"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "pamixer" "-d" "5"; }
        XF86AudioMute allow-when-locked=true { spawn "pamixer" "-t"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }

        // Session
        Mod+Shift+E { quit; }
    }
  '';
}
