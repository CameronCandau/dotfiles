#!/usr/bin/env bash

set -euo pipefail

pane_id="${1:-}"

if [ -z "$pane_id" ]; then
  exit 1
fi

sanitize() {
  printf '%s' "$1" | tr -cs 'A-Za-z0-9._-' '_'
}

is_logging="$(tmux show-option -p -t "$pane_id" -v @output_logging 2>/dev/null || true)"

if [ "$is_logging" = "on" ]; then
  log_file="$(tmux show-option -p -t "$pane_id" -v @output_log_file 2>/dev/null || true)"
  tmux pipe-pane -t "$pane_id"
  tmux set-option -p -t "$pane_id" @output_logging off
  tmux set-option -p -t "$pane_id" @output_log_file ""
  tmux display-message "Output logging stopped${log_file:+: $log_file}"
  exit 0
fi

session_name="$(sanitize "$(tmux display-message -p -t "$pane_id" '#S')")"
window_name="$(sanitize "$(tmux display-message -p -t "$pane_id" '#W')")"
pane_index="$(tmux display-message -p -t "$pane_id" '#P')"
timestamp="$(date +%H%M%S)"
log_dir="$HOME/logs/tmux/$(date +%F)/$session_name"
log_file="$log_dir/${window_name}_pane${pane_index}_${timestamp}.log"

mkdir -p "$log_dir"
tmux pipe-pane -o -t "$pane_id" "cat >> $(printf '%q' "$log_file")"
tmux set-option -p -t "$pane_id" @output_logging on
tmux set-option -p -t "$pane_id" @output_log_file "$log_file"
tmux display-message "Output logging to $log_file"
