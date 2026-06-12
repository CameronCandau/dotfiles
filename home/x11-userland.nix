{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    bashInteractive
    curl
    eza
    fd
    git
    jq
    lf
    neofetch
    ripgrep
    starship
    tmux
    tree
    unzip
    xclip
    xsel
    zip
    zoxide
  ];
}
