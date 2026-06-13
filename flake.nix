{
  description = "Home Manager dotfiles and reusable desktop modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }: {
    homeModules = {
      core = import ./home/core.nix;
      sharedCli = import ./home/shared-cli.nix;
      neovim = import ./home/neovim.nix;
      opindex = import ./home/opindex.nix;
      tmux = import ./home/tmux.nix;
      x11Userland = import ./home/x11-userland.nix;
      desktopI3 = import ./home/desktop-i3.nix;
      classicI3 = import ./home/classic-i3.nix;
      waylandBase = import ./home/wayland-base.nix;
    };
  };
}
