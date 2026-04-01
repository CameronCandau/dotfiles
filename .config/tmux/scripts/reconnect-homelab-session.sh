#!/usr/bin/env bash

set -euo pipefail

session="${1:-homelab}"

trim() {
  printf '%s' "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

label_for() {
  local label

  label="$(printf '%s' "$1" | sed 's/[^A-Za-z0-9._-]/-/g')"
  label="${label#-}"
  label="${label%-}"
  printf '%s' "${label:-host}"
}

if ! tmux has-session -t "$session" 2>/dev/null; then
  tmux display-message "Session $session does not exist yet."
  exit 0
fi

targets_csv="$(tmux show-option -t "$session" -qv @homelab_targets || tmux show-option -gqv @homelab_targets || true)"
targets_csv="$(trim "$targets_csv")"

if [ -z "$targets_csv" ]; then
  tmux display-message "No saved homelab targets for $session. Bootstrap it first with prefix + A."
  exit 0
fi

IFS=',' read -r -a raw_targets <<< "$targets_csv"
for raw_target in "${raw_targets[@]}"; do
  target="$(trim "$raw_target")"
  [ -n "$target" ] || continue

  label="$(label_for "$target")"

  if ! tmux list-windows -t "$session" -F '#W' | grep -Fxq "$label"; then
    tmux new-window -d -t "$session" -n "$label" "ssh $target"
    continue
  fi

  pane_id="$(tmux list-panes -t "$session:$label" -F '#{pane_id}' | head -n 1)"
  [ -n "$pane_id" ] || continue

  tmux send-keys -t "$pane_id" C-c
  tmux send-keys -t "$pane_id" "ssh $target" Enter
done

tmux display-message "Homelab reconnect triggered for $session. Unlock KeePassXC first if SSH keys are still locked."
