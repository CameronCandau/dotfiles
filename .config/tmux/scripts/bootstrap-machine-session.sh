#!/usr/bin/env bash

set -euo pipefail

name="${1:-}"
shell_cmd="${SHELL:-}"
new_target_bin="$(command -v new-target || true)"
workspace_lib=""

if command -v zsh >/dev/null 2>&1; then
  shell_cmd="$(command -v zsh) -l"
fi

if [ -z "$name" ]; then
  exit 0
fi

if [ -n "$new_target_bin" ]; then
  workspace_lib="$(dirname "$new_target_bin")/_target-workspace-lib"
fi

if [ -z "$workspace_lib" ] || [ ! -f "$workspace_lib" ]; then
  printf 'bootstrap-machine-session: could not find _target-workspace-lib next to new-target\n' >&2
  exit 1
fi

source "$workspace_lib"

target_dir="$(ensure_target_workspace "$name")"

if tmux has-session -t "$name" 2>/dev/null; then
  if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$name"
  else
    tmux attach-session -t "$name"
  fi
  exit 0
fi

tmux new-session -d -s "$name" -n enum -c "$target_dir" "$shell_cmd"
tmux new-window -d -t "$name" -n exploit -c "$target_dir" "$shell_cmd"
tmux new-window -d -t "$name" -n shell -c "$target_dir" "$shell_cmd"
tmux select-window -t "$name:1"
tmux select-pane -t "$name:1.1"
tmux send-keys -t "$name:1.1" C-c

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$name"
else
  tmux attach-session -t "$name"
fi
