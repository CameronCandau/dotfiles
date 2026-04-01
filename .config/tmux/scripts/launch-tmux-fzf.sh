#!/usr/bin/env bash

set -euo pipefail

plugin="/home/exis/dotfiles/.config/tmux/plugins/tmux-fzf/main.sh"

if ! command -v fzf >/dev/null 2>&1; then
  tmux display-message "tmux-fzf is installed, but fzf is not. Install fzf to enable prefix + F."
  exit 0
fi

if [ ! -x "$plugin" ]; then
  tmux display-message "tmux-fzf plugin not found at $plugin"
  exit 1
fi

exec "$plugin"
