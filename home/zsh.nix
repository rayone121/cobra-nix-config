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
      # Zinit
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      if [ ! -d "$ZINIT_HOME" ]; then
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi
      source "''${ZINIT_HOME}/zinit.zsh"

      zinit light zsh-users/zsh-completions
      zinit light Aloxaf/fzf-tab

      # Keybindings
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # Completion styling
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
      version = 2;
      final_space = true;
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
              properties.style = "full";
            }
            {
              type = "git";
              style = "plain";
              foreground = "#98C379";
              template = " {{ .HEAD }}{{ if .Staging.Changed }} +{{ .Staging.String }}{{ end }}{{ if .Working.Changed }} ~{{ .Working.String }}{{ end }}";
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
              template = ">";
            }
          ];
        }
      ];
    };
  };
}
