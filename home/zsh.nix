{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      cat = "bat";
      cd = "z";
      ".." = "z ..";
      "..." = "z ../..";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#cobra";
      update = "nix flake update --flake ~/.config/nixos";
      wifi = "nmtui";
      vol = "pulsemixer";
      bt = "bluetuith";
    };

    initContent = ''
      # ---------- Zinit ----------
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      if [ ! -d "$ZINIT_HOME" ]; then
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi
      source "''${ZINIT_HOME}/zinit.zsh"

      # Zinit plugins
      zinit light zsh-users/zsh-completions
      zinit light Aloxaf/fzf-tab

      # ---------- Keybindings ----------
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      # ---------- Completion styling ----------
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always $realpath'
      zstyle ':fzf-tab:complete:z:*' fzf-preview 'lsd --color=always $realpath'
    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      version = 2;
      final_space = true;
      console_title_template = "{{ .Shell }} in {{ .Folder }}";
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              type = "path";
              style = "plain";
              foreground = "#61AFEF";
              template = "{{ .Path }}";
              properties = {
                style = "full";
              };
            }
            {
              type = "git";
              style = "plain";
              foreground = "#98C379";
              template = " {{ .HEAD }}{{ if .Staging.Changed }} \u2022{{ .Staging.String }}{{ end }}{{ if .Working.Changed }} \u00b1{{ .Working.String }}{{ end }}";
            }
            {
              type = "nix-shell";
              style = "plain";
              foreground = "#7DCFFF";
              template = " \u2744\ufe0f nix";
            }
          ];
        }
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              type = "text";
              style = "plain";
              foreground = "#C678DD";
              template = "\u276f";
            }
          ];
        }
      ];
    };
  };
}
