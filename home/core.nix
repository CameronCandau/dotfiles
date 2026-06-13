{ ... }:
{
  imports = [
    ./shared-cli.nix
    ./neovim.nix
    ./tmux.nix
  ];

  home.file.".xsessionrc".text = ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    fi
  '';
}
