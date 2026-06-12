# dotfiles

Shared Home Manager flake for my reusable dotfiles and desktop modules.

Modules:

- `homeModules.core`
  Shared shell/editor/tmux/nvim/starship state that is independent of X11 or Wayland.
- `homeModules.x11Userland`
  X11-era userland choices such as Alacritty and X clipboard tools.
- `homeModules.desktopI3`
  i3 support assets and packages: scripts, i3status, and wallpapers.
- `homeModules.classicI3`
  The classic i3 and rofi configs copied from the existing dotfiles.
- `homeModules.waylandBase`
  Minimal Wayland-oriented terminal/clipboard/screenshot layer for future Niri or similar work.

Intended usage:

```nix
imports = [
  inputs.dotfiles.homeModules.core
  inputs.dotfiles.homeModules.x11Userland
  inputs.dotfiles.homeModules.desktopI3
  inputs.dotfiles.homeModules.classicI3
];
```

The repo is now the Home Manager-owned source of truth for the shared shell,
editor, terminal, and desktop configuration layers.
