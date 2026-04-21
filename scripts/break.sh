#!/usr/bin/env bash
# Body of the break popup. Polls the state file each second so an external
# reset (prefix + E) closes this popup cleanly.

state_file="${TMPDIR:-/tmp}/tmux-eyerest-${USER:-user}.state"
break_sec=$(tmux show-option -gqv "@eyerest-break-seconds")
break_sec=${break_sec:-20}
msg=$(tmux show-option -gqv "@eyerest-break-message")
msg=${msg:-"Look at something 20 feet away"}

while true; do
    phase=""
    start=""
    if [ -f "$state_file" ]; then
        IFS=: read -r phase start < "$state_file" 2>/dev/null || true
    fi
    [ "$phase" != "break" ] && exit 0

    now=$(date +%s)
    remaining=$(( break_sec - (now - ${start:-$now}) ))
    [ "$remaining" -le 0 ] && break

    clear
    printf '\n'
    printf '    👁  20-20-20 EYE BREAK\n\n'
    printf '    %s\n\n' "$msg"
    printf '    %2d seconds remaining\n' "$remaining"
    printf '\n    q: skip   any other key: dismiss popup\n'

    key=""
    read -rsn1 -t 1 key || true
    case "$key" in
        q)
            printf 'work:%s\n' "$now" > "$state_file.tmp" && mv "$state_file.tmp" "$state_file"
            exit 0 ;;
        "") : ;;
        *) exit 0 ;;
    esac
done

clear
printf '\n\n    ✓ Break complete. Back to work.\n'
sleep 1
