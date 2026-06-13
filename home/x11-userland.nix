{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    curl
    fd
    git
    jq
    ripgrep
    unzip
    xclip
    xsel
    zip
  ];
}
