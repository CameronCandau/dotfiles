{ pkgs, ... }:
{
  home.packages = with pkgs; [
    foot
    grim
    slurp
    wl-clipboard
  ];
}
