#!/usr/bin/env bash
# Printed on every tmux status refresh. Sole source of truth for phase transitions
# driven by elapsed time; keybind-driven transitions live in control.sh.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
state_file="${TMPDIR:-/tmp}/tmux-eyerest-${USER:-user}.state"

work_min=$(tmux show-option -gqv "@eyerest-work-minutes")
work_min=${work_min:-20}
break_sec=$(tmux show-option -gqv "@eyerest-break-seconds")
break_sec=${break_sec:-20}
icon=$(tmux show-option -gqv "@eyerest-icon")
icon=${icon:-👁}

work_sec=$(( work_min * 60 ))
now=$(date +%s)

phase=""
start=""
if [ -f "$state_file" ]; then
    IFS=: read -r phase start < "$state_file" 2>/dev/null || true
fi
phase=${phase:-work}
start=${start:-$now}

elapsed=$(( now - start ))

write_state() {
    printf '%s:%s\n' "$1" "$2" > "$state_file.tmp" && mv "$state_file.tmp" "$state_file"
}

if [ "$phase" = "work" ] && [ "$elapsed" -ge "$work_sec" ]; then
    write_state break "$now"
    phase=break
    elapsed=0
    tmux run-shell -b "$SCRIPT_DIR/notify.sh"
elif [ "$phase" = "break" ] && [ "$elapsed" -ge "$break_sec" ]; then
    write_state work "$now"
    phase=work
    elapsed=0
fi

if [ "$phase" = "work" ]; then
    remaining=$(( work_sec - elapsed ))
    mins=$(( remaining / 60 ))
    secs=$(( remaining % 60 ))
    printf '%s %d:%02d' "$icon" "$mins" "$secs"
else
    remaining=$(( break_sec - elapsed ))
    [ "$remaining" -lt 0 ] && remaining=0
    printf '%s BREAK %ds' "$icon" "$remaining"
fi
