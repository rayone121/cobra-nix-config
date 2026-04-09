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
      # ls/ll/lt provided by programs.lsd.enableZshIntegration
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

    # Zinit setup
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
    settings = builtins.fromJSON (builtins.readFile ../dotfiles/oh-my-posh.json);
  };
}
