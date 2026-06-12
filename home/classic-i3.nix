{ ... }:
{
  home.file.".config/i3/config".source = ../files/i3/config;

  home.file.".config/rofi" = {
    recursive = true;
    source = ../files/rofi;
  };
}
