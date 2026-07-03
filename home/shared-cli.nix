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

      export HISTCONTROL=ignoreboth
      shopt -s histappend checkwinsize
      HISTSIZE=1000
      HISTFILESIZE=2000

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
