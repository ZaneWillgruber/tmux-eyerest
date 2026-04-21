# tmux-eyerest

A tmux plugin that nudges you to follow the **20-20-20 rule**:
every 20 minutes of screen time, look at something 20 feet away for 20 seconds.

- Ticking countdown in your tmux status bar
- Popup break prompt when a break is due
- Configurable durations, icon, message, and keys
- Keybinds to start a break now or reset the timer

## Install

### With [TPM](https://github.com/tmux-plugins/tpm)

In `~/.tmux.conf`:

```tmux
set -g @plugin 'youruser/tmux-eyerest'
set -g status-right '#{eyerest} | %H:%M '
```

Then hit `prefix + I` to fetch and source.

### Manual

```sh
git clone https://github.com/youruser/tmux-eyerest ~/.tmux/plugins/tmux-eyerest
```

In `~/.tmux.conf`, after your `status-left` / `status-right` settings:

```tmux
set -g status-right '#{eyerest} | %H:%M '
run-shell ~/.tmux/plugins/tmux-eyerest/eyerest.tmux
```

The `#{eyerest}` placeholder is substituted by the plugin with a live status interpolation.

## Configuration

Set these before the `run-shell` / TPM line.

| Option                    | Default                           | Purpose                                            |
| ------------------------- | --------------------------------- | -------------------------------------------------- |
| `@eyerest-work-minutes`   | `20`                              | Minutes between breaks                             |
| `@eyerest-break-seconds`  | `20`                              | Length of each break                               |
| `@eyerest-icon`           | `👁`                              | Icon shown in the status bar                       |
| `@eyerest-break-message`  | `Look at something 20 feet away`  | Text shown in the popup                            |
| `@eyerest-break-key`      | `e`                               | `prefix + <key>` — take a break immediately        |
| `@eyerest-reset-key`      | `E`                               | `prefix + <key>` — reset timer / dismiss the break |

Example:

```tmux
set -g @eyerest-work-minutes 25
set -g @eyerest-break-seconds 30
set -g @eyerest-icon '🕐'
set -g @eyerest-break-key 'B'
```

## Keybinds

- `prefix + e` — take a break now (opens the break popup immediately)
- `prefix + E` — reset the work timer and dismiss any active break

Inside the break popup:

- `q` — skip the break and resume work
- any other key — dismiss the popup (break keeps counting down in the status bar)

## Notes

- The countdown only ticks as fast as your `status-interval`. For a smooth one-second tick:
  ```tmux
  set -g status-interval 1
  ```
- State is stored in `$TMPDIR/tmux-eyerest-$USER.state` and reset whenever the plugin is sourced (e.g. `tmux source ~/.tmux.conf`).
- Popups require tmux **3.2+**. Older tmux falls back to `display-message`.

## License

MIT
