{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    feh
    flameshot
    i3status
    rofi
    xdotool
    xorg.xinput
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
