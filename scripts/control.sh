#!/usr/bin/env bash
# Keybind-driven state changes. Status refresh picks up the new state on its next tick.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
state_file="${TMPDIR:-/tmp}/tmux-eyerest-${USER:-user}.state"
now=$(date +%s)

write_state() {
    printf '%s:%s\n' "$1" "$2" > "$state_file.tmp" && mv "$state_file.tmp" "$state_file"
}

case "${1:-}" in
    break-now)
        write_state break "$now"
        "$SCRIPT_DIR/notify.sh"
        ;;
    reset)
        # Flipping to work causes any active break popup to exit on its next poll.
        write_state work "$now"
        ;;
    *)
        echo "usage: $0 {break-now|reset}" >&2
        exit 1
        ;;
esac
