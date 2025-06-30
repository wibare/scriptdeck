#!/usr/bin/env bash

shopt -s nullglob

# Supported image extensions
image_exts=("jpg" "jpeg" "png" "webp" "bmp" "tiff")

# Check arguments
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <image_or_directory> <width|auto> <height|auto>"
    exit 1
fi

input="$1"
width="$2"
height="$3"

# Build resize size
if [[ "$width" == "auto" && "$height" == "auto" ]]; then
    echo "Error: both width and height cannot be 'auto'."
    exit 1
elif [[ "$width" == "auto" ]]; then
    size="x${height}"
elif [[ "$height" == "auto" ]]; then
    size="${width}"
else
    size="${width}x${height}!"
fi

# Select ImageMagick command
if command -v magick >/dev/null 2>&1; then
    im_cmd="magick convert"
elif command -v convert >/dev/null 2>&1; then
    im_cmd="convert"
else
    echo "Error: ImageMagick is not installed."
    exit 1
fi

# Resize function
resize_image() {
    local img="$1"
    local out_dir="$2"
    local filename="$(basename "$img")"
    local name="${filename%.*}"
    local ext="${filename##*.}"
    local output="$out_dir/${name}.${ext}"
    $im_cmd "$img" -resize "$size" "$output"
    echo "✔ Resized: $filename → $output"
}

# If input is a directory
if [[ -d "$input" ]]; then
    resized_dir="$input/resized"
    mkdir -p "$resized_dir"

    found=false
    for ext in "${image_exts[@]}"; do
        for img in "$input"/*."$ext"; do
            found=true
            resize_image "$img" "$resized_dir"
        done
    done

    if ! $found; then
        echo "No supported images found in: $input"
        exit 1
    fi

    echo "All resized images saved in: $resized_dir"

# If input is a single image file
elif [[ -f "$input" ]]; then
    dir="$(dirname "$input")"
    resized_dir="$dir/resized"
    mkdir -p "$resized_dir"
    resize_image "$input" "$resized_dir"
    echo "Resized image saved in: $resized_dir"
else
    echo "Error: '$input' is not a valid file or directory."
    exit 1
fi

