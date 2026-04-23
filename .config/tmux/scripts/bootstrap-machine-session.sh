#!/usr/bin/env bash

set -euo pipefail

name="${1:-}"
shell_cmd="${SHELL:-}"

if command -v zsh >/dev/null 2>&1; then
  shell_cmd="$(command -v zsh) -l"
fi

if [ -z "$name" ]; then
  exit 0
fi

if tmux has-session -t "$name" 2>/dev/null; then
  if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$name"
  else
    tmux attach-session -t "$name"
  fi
  exit 0
fi

tmux new-session -d -s "$name" -n enum "$shell_cmd"
tmux new-window -d -t "$name" -n exploit "$shell_cmd"
tmux new-window -d -t "$name" -n shell "$shell_cmd"
tmux new-window -d -t "$name" -n notes "$shell_cmd"
tmux select-window -t "$name:1"
tmux select-pane -t "$name:1.1"
tmux send-keys -t "$name:1.1" C-c

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$name"
else
  tmux attach-session -t "$name"
fi
