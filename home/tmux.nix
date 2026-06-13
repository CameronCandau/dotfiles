{ ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    escapeTime = 0;
    historyLimit = 100000;
    extraConfig = builtins.readFile ../files/tmux/tmux.conf;
  };
}
