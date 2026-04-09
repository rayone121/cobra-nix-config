{ config, pkgs, lib, userConfig, ... }:

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
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#${userConfig.hostname}";
      update = "nix flake update --flake ~/.config/nixos";
      wifi = "nmtui";
      vol = "pulsemixer";
      bt = "bluetuith";
    };

    initContent = ''
      # Zinit
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      if [ ! -d "$ZINIT_HOME" ]; then
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi
      source "''${ZINIT_HOME}/zinit.zsh"

      zinit light zsh-users/zsh-completions
      zinit light Aloxaf/fzf-tab

      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

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
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              type = "text";
              style = "plain";
              foreground = "#ffffff";
              template = "<#C591E8>❯</><#69FF94>❯</> ";
            }
            {
              type = "path";
              style = "plain";
              foreground = "#56B6C2";
              template = "{{ .Path }} ";
              properties.style = "folder";
            }
            {
              type = "git";
              style = "plain";
              foreground = "#D0666F";
              template = "<#5FAAE8>git:(</> {{ .HEAD }}<#5FAAE8>)</>";
              properties.branch_icon = "";
            }
            {
              type = "status";
              style = "plain";
              foreground = "#DCB977";
              template = " 😞 ";
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
              foreground = "#ffffff";
              template = "❯ ";
            }
          ];
        }
      ];
    };
  };
}
