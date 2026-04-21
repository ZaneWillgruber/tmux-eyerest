#!/usr/bin/env bash
# Opens the break popup, or falls back to a dedicated window on tmux < 3.2.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if ! tmux display-popup -E -w 50 -h 9 "$SCRIPT_DIR/break.sh" 2>/dev/null; then
    tmux new-window -n "eye-break" "$SCRIPT_DIR/break.sh"
fi
