#!/usr/bin/env bash

# Check argument
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <image_file>"
    exit 1
fi

image="$1"

# Check if file exists and is readable
if [[ ! -f "$image" || ! -r "$image" ]]; then
    echo "Error: '$image' is not a readable file."
    exit 1
fi

# Get MIME type
mime_type=$(file --mime-type -b "$image")

# Only allow image MIME types
if [[ "$mime_type" != image/* ]]; then
    echo "Error: '$image' is not a valid image file."
    exit 1
fi

# Detect environment and copy
if [[ "$XDG_SESSION_TYPE" == "wayland" || -n "$WAYLAND_DISPLAY" ]]; then
    if command -v wl-copy >/dev/null 2>&1; then
        cat "$image" | wl-copy --type "$mime_type"
        echo "Image copied to clipboard using wl-copy (Wayland)."
        exit 0
    else
        echo "Error: Wayland detected but 'wl-copy' is not installed."
        exit 1
    fi
elif [[ -n "$DISPLAY" ]]; then
    if command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard -t "$mime_type" -i "$image"
        echo "Image copied to clipboard using xclip (X11)."
        exit 0
    else
        echo "Error: X11 detected but 'xclip' is not installed."
        exit 1
    fi
else
    echo "Error: No supported graphical session detected (Wayland or X11)."
    exit 1
fi

