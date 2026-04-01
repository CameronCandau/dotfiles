#!/usr/bin/env bash

set -euo pipefail

session="${1:-homelab}"
targets_csv="${2:-}"

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

if [ -z "$targets_csv" ]; then
  targets_csv="$(tmux show-option -gqv @homelab_targets || true)"
fi

targets_csv="$(trim "$targets_csv")"

if [ -z "$targets_csv" ]; then
  tmux display-message "No homelab targets configured. Use prefix + A with comma-separated SSH targets."
  exit 0
fi

IFS=',' read -r -a raw_targets <<< "$targets_csv"
targets=()
for raw_target in "${raw_targets[@]}"; do
  target="$(trim "$raw_target")"
  if [ -n "$target" ]; then
    targets+=("$target")
  fi
done

if [ "${#targets[@]}" -eq 0 ]; then
  tmux display-message "No valid homelab targets found."
  exit 0
fi

joined_targets="$(IFS=,; printf '%s' "${targets[*]}")"
tmux set-option -gq @homelab_targets "$joined_targets"

if ! tmux has-session -t "$session" 2>/dev/null; then
  first_target="${targets[0]}"
  first_label="$(label_for "$first_target")"
  tmux new-session -d -s "$session" -n "$first_label" "ssh $first_target"
else
  first_label="$(label_for "${targets[0]}")"
fi

tmux set-option -t "$session" -q @homelab_targets "$joined_targets"

for target in "${targets[@]}"; do
  label="$(label_for "$target")"

  if ! tmux list-windows -t "$session" -F '#W' | grep -Fxq "$label"; then
    tmux new-window -d -t "$session" -n "$label" "ssh $target"
  fi
done

if ! tmux list-windows -t "$session" -F '#W' | grep -Fxq "notes"; then
  tmux new-window -d -t "$session" -n notes
fi

tmux select-window -t "$session:$first_label"

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$session"
else
  tmux attach-session -t "$session"
fi
