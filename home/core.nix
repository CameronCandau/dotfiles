{ ... }:
{
  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -lah";
      la = "eza -a";
      tree = "eza --tree";
    };
    initExtra = ''
      export HISTCONTROL=ignoreboth
      shopt -s histappend checkwinsize
      HISTSIZE=50000
      HISTFILESIZE=100000
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file.".tmux.conf".source = ../files/tmux/tmux.conf;
  home.file.".vimrc".source = ../files/vimrc;
  home.file.".config/starship.toml".source = ../files/starship.toml;

  home.file.".config/tmux/scripts" = {
    recursive = true;
    source = ../files/tmux/scripts;
  };

  home.file.".config/nvim" = {
    recursive = true;
    source = ../files/nvim;
  };

  home.file.".config/lf" = {
    recursive = true;
    source = ../files/lf;
  };

  home.file.".config/neofetch" = {
    recursive = true;
    source = ../files/neofetch;
  };

  home.file.".config/opindex" = {
    recursive = true;
    source = ../files/opindex;
  };

  home.file.".config/artifact-catalog" = {
    recursive = true;
    source = ../files/artifact-catalog;
  };

  home.file.".xsessionrc".text = ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    fi

    export PATH="$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH"
  '';

  home.file.".zprofile".text = ''
    export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:$PATH"
  '';
}
