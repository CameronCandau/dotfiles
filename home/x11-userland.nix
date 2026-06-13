{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    fd
    git
    jq
    ripgrep
    unzip
    xfce.xfce4-terminal
    xclip
    xsel
    zip
  ];

  home.file.".config/xfce4/terminal/terminalrc".source = ../files/xfce4-terminal/terminalrc;
}
