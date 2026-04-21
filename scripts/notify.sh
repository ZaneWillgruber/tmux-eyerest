#!/usr/bin/env bash
# Opens the break popup, or falls back to a tmux message on older tmux builds.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
msg=$(tmux show-option -gqv "@eyerest-break-message")
msg=${msg:-"Look at something 20 feet away"}

if ! tmux display-popup -E -w 50 -h 9 "$SCRIPT_DIR/break.sh" 2>/dev/null; then
    tmux display-message -d 5000 "Eye break: $msg"
fi
