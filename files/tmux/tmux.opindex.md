# tmux

## Use the default tmux prefix key
```
Ctrl-b
# Inferred from local config: no custom prefix is set in tmux.conf.
```

## Create a new window
```
Ctrl-b c
```

## Switch to the next or previous window
```
Ctrl-b n
Ctrl-b p
```

## List windows
```
Ctrl-b w
```

## Rename the current window
```
Ctrl-b ,
```

## Split the current pane vertically or horizontally
```
Ctrl-b %
Ctrl-b "
```

## Move between panes without using the prefix
```
Alt-h
Alt-j
Alt-k
Alt-l
```

## Zoom or unzoom the current pane
```
Ctrl-b z
```

## Show pane numbers for quick targeting
```
Ctrl-b q
```

## Enter copy mode
```
Enter
```

## Select and yank text in copy mode
```
v
y
```

## Detach from the current tmux session
```
Ctrl-b d
```

## Create a tmux session
```bash
tmux new-session -s <session-name>
```

## Rename a tmux session
```bash
tmux rename-session -t <old-session-name> <new-session-name>
```

## Delete a tmux session
```bash
tmux kill-session -t <session-name>
```
