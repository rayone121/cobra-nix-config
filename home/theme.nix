{ config, pkgs, lib, userConfig, ... }:

{
  # ---------- Dunst notifications ----------
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 350;
        height = 150;
        offset = "10x10";
        origin = "top-right";
        transparency = 10;
        frame_color = "#fbb829";
        frame_width = 2;
        corner_radius = 8;
        font = "JetBrainsMono Nerd Font 11";
        padding = 12;
        horizontal_padding = 12;
        separator_color = "frame";
        icon_position = "left";
        max_icon_size = 48;
      };
      urgency_low = {
        background = "#1c1b19";
        foreground = "#baa67f";
        timeout = 5;
      };
      urgency_normal = {
        background = "#1c1b19";
        foreground = "#fce8c3";
        timeout = 10;
      };
      urgency_critical = {
        background = "#1c1b19";
        foreground = "#ef2f27";
        frame_color = "#ef2f27";
        timeout = 0;
      };
    };
  };

  # ---------- Fuzzel launcher ----------
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=12
    prompt="  "
    terminal=kitty
    layer=overlay
    width=45
    lines=12
    horizontal-pad=16
    vertical-pad=12
    inner-pad=8

    [colors]
    background=1c1b19ee
    text=fce8c3ff
    match=fbb829ff
    selection=2a2927ff
    selection-text=fbb829ff
    selection-match=fed06eff
    border=fbb829ff

    [border]
    width=2
    radius=8
  '';

  # ---------- Swaylock ----------
  programs.swaylock = {
    enable = true;
    settings = {
      color = "1c1b19";
      font = "JetBrainsMono Nerd Font";
      font-size = 18;
      indicator-radius = 100;
      indicator-thickness = 8;
      inside-color = "1c1b19";
      inside-clear-color = "1c1b19";
      inside-ver-color = "1c1b19";
      inside-wrong-color = "1c1b19";
      key-hl-color = "fbb829";
      bs-hl-color = "ef2f27";
      ring-color = "918175";
      ring-clear-color = "519f50";
      ring-ver-color = "2c78bf";
      ring-wrong-color = "ef2f27";
      text-color = "fce8c3";
      text-clear-color = "fce8c3";
      text-ver-color = "fce8c3";
      text-wrong-color = "ef2f27";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      separator-color = "00000000";
      show-failed-attempts = true;
    };
  };
}
