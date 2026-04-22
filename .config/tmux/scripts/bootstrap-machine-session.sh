#!/usr/bin/env bash

set -euo pipefail

name="${1:-}"

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

tmux new-session -d -s "$name" -n enum
tmux new-window -d -t "$name" -n exploit
tmux new-window -d -t "$name" -n shell
tmux new-window -d -t "$name" -n notes
tmux select-window -t "$name:1"
tmux select-pane -t "$name:1.1"
tmux send-keys -t "$name:1.1" C-c

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$name"
else
  tmux attach-session -t "$name"
fi
