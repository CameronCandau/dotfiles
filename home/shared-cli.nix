{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.nix-profile/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -lah --git";
      la = "eza -a";
      tree = "eza --tree";
    };
    initExtra = ''
      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi

      export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:$PATH"

      # Append to $HISTFILE, don't overwrite
      shopt -s histappend

      # Increase max length of session history
      HISTSIZE=100000
      # Increase max length of history file
      HISTFILESIZE=200000

      # Don't ignore/delete duplicates, just ignore commands starting with space
      export HISTCONTROL=ignorespace
      # Log when commands were run
      HISTTIMEFORMAT='%F %T  '

      # Save commands with multiple lines as one history entry
      shopt -s cmdhist
      shopt -s lithist

      # At every prompt, append current session's history to $HISTFILE. Allows all new shells to open with an updated copy of history from all other shells.
      PROMPT_COMMAND='history -a'

      # Search history by the current line prefix with up/down arrows.
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'

      term-log() {
        local label="''${1:-session}"
        local dir="$HOME/logs"

        mkdir -p "$dir" || return 1
        script -a "$dir/''${label}.log"
      }

      y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd

        command yazi "$@" --cwd-file="$tmp"

        IFS= read -r -d "" cwd < "$tmp" || true

        if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ]; then
          builtin cd -- "$cwd"
        fi

        command rm -f -- "$tmp"
      }
    '';
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  home.packages = with pkgs; [
    harper
    yazi
    gh
  ];

  home.file.".config/starship.toml".source = ../files/starship.toml;
  home.file.".config/yazi/yazi.toml".source = ../files/yazi/yazi.toml;
}
