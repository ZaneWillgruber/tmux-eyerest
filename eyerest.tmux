#!/usr/bin/env bash
# tmux-eyerest: 20-20-20 eye strain reminder plugin.
# TPM entry point — invoked once when tmux sources the plugin.

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set_default() {
    local opt="$1" val="$2"
    if [ -z "$(tmux show-option -gqv "$opt")" ]; then
        tmux set-option -gq "$opt" "$val"
    fi
}

set_default "@eyerest-work-minutes"   "20"
set_default "@eyerest-break-seconds"  "20"
set_default "@eyerest-icon"           "👁"
set_default "@eyerest-break-message"  "Look at something 20 feet away"
set_default "@eyerest-break-key"      "e"
set_default "@eyerest-reset-key"      "E"

# Fresh timer on plugin load so a long tmux shutdown doesn't trigger an instant break.
state_file="${TMPDIR:-/tmp}/tmux-eyerest-${USER:-user}.state"
printf 'work:%s\n' "$(date +%s)" > "$state_file"

# Swap #{eyerest} in status-left / status-right for our status script interpolation.
replacement="#($CURRENT_DIR/scripts/status.sh)"
for opt in status-left status-right; do
    val=$(tmux show-option -gqv "$opt")
    new_val=$(printf '%s' "$val" | awk -v r="$replacement" '{gsub(/#\{eyerest\}/, r); print}')
    if [ "$new_val" != "$val" ]; then
        tmux set-option -gq "$opt" "$new_val"
    fi
done

break_key=$(tmux show-option -gqv "@eyerest-break-key")
reset_key=$(tmux show-option -gqv "@eyerest-reset-key")
tmux bind-key "$break_key" run-shell -b "$CURRENT_DIR/scripts/control.sh break-now"
tmux bind-key "$reset_key" run-shell -b "$CURRENT_DIR/scripts/control.sh reset"
