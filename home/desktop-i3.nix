{ pkgs, ... }:
{
  home.packages = with pkgs; [
    arandr
    feh
    flameshot
    i3lock
    i3status
    libnotify
    networkmanagerapplet
    rofi
    xorg.xrandr
  ];

  home.file.".config/i3/scripts" = {
    recursive = true;
    source = ../files/i3/scripts;
  };

  home.file.".config/i3status" = {
    recursive = true;
    source = ../files/i3status;
  };

  home.file.".config/wallpapers" = {
    recursive = true;
    source = ../files/wallpapers;
  };
}
