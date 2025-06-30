#!/usr/bin/env bash

# Check argument
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file="$1"

# Verify that the file exists and is readable
if [[ ! -f "$file" || ! -r "$file" ]]; then
    echo "Error: '$file' is not a readable file."
    exit 1
fi

# Detect graphical session and copy
if [[ "$XDG_SESSION_TYPE" == "wayland" || -n "$WAYLAND_DISPLAY" ]]; then
    if command -v wl-copy >/dev/null 2>&1; then
        cat "$file" | wl-copy
        echo "Copied to clipboard using wl-copy (Wayland)."
        exit 0
    else
        echo "Error: Wayland detected, but 'wl-copy' is not installed."
        exit 1
    fi
elif [[ -n "$DISPLAY" ]]; then
    if command -v xclip >/dev/null 2>&1; then
        cat "$file" | xclip -selection clipboard
        echo "Copied to clipboard using xclip (X11)."
        exit 0
    else
        echo "Error: X11 detected, but 'xclip' is not installed."
        exit 1
    fi
else
    echo "Error: No supported graphical session detected (Wayland or X11)."
    exit 1
fi

