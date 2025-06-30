#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

print_usage() {
    echo "Usage: $0 <source_file_or_directory> <target_format>"
    echo "Example:"
    echo "  $0 song.wav mp3"
    echo "  $0 ./music_folder ogg"
    exit 1
}

check_ffmpeg() {
    if ! command -v ffmpeg >/dev/null 2>&1; then
        echo "Error: ffmpeg is not installed. Install it and try again."
        exit 1
    fi
}

convert_file() {
    local input_file="$1"
    local target_format="$2"

    local dir_name base_name output_dir output_file
    dir_name="$(dirname "$input_file")"
    base_name="$(basename "$input_file")"
    base_name="${base_name%.*}"
    output_dir="${dir_name}/converted"
    output_file="${output_dir}/${base_name}.${target_format}"

    mkdir -p "$output_dir"

    if [[ -f "$output_file" ]]; then
        echo "Skipping: '$output_file' already exists."
        return
    fi

    echo "Converting '$input_file' -> '$output_file'"
    if ! ffmpeg -loglevel error -y -i "$input_file" -map_metadata -1 "$output_file" 2>/dev/null; then
        echo "Error: Failed to convert '$input_file'"
    fi
}

convert_directory() {
    local dir_path="$1"
    local target_format="$2"
    local supported_exts=("wav" "mp3" "ogg" "flac" "m4a" "aac")

    shopt -s nullglob nocaseglob
    for ext in "${supported_exts[@]}"; do
        for file in "$dir_path"/*."$ext"; do
            if [[ -f "$file" ]]; then
                convert_file "$file" "$target_format"
            fi
        done
    done
    shopt -u nullglob nocaseglob
}

main() {
    if [[ $# -ne 2 ]]; then
        print_usage
    fi

    local source="$1"
    local target_format="$2"

    check_ffmpeg

    if [[ -f "$source" ]]; then
        convert_file "$source" "$target_format"
    elif [[ -d "$source" ]]; then
        convert_directory "$source" "$target_format"
    else
        echo "Error: '$source' is not a valid file or directory."
        exit 1
    fi
}

main "$@"
