#!/bin/bash

set -euo pipefail

# Check if input file was provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <archive_file>"
    exit 1
fi

input_file="$1"

# Check if file exists
if [[ ! -f "$input_file" ]]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Extract directory name (without extension)
basename=$(basename -- "$input_file")
filename="${basename%.*}"

# Create output directory
output_dir="${filename}_extracted"
mkdir -p "$output_dir"

# Detect file type
mime_type=$(file --mime-type -b "$input_file")

case "$mime_type" in
    application/zip)
        unzip -qq "$input_file" -d "$output_dir"
        ;;
    application/x-gzip)
        if [[ "$input_file" == *.tar.gz || "$input_file" == *.tgz ]]; then
            tar -xzf "$input_file" -C "$output_dir"
        else
            gunzip -c "$input_file" > "$output_dir/${filename}"
        fi
        ;;
    application/x-bzip2)
        if [[ "$input_file" == *.tar.bz2 ]]; then
            tar -xjf "$input_file" -C "$output_dir"
        else
            bunzip2 -c "$input_file" > "$output_dir/${filename}"
        fi
        ;;
    application/x-xz)
        if [[ "$input_file" == *.tar.xz ]]; then
            tar -xJf "$input_file" -C "$output_dir"
        else
            unxz -c "$input_file" > "$output_dir/${filename}"
        fi
        ;;
    application/x-tar)
        tar -xf "$input_file" -C "$output_dir"
        ;;
    application/x-7z-compressed)
        7z x -y -o"$output_dir" "$input_file" >/dev/null
        ;;
    application/x-rar)
        unrar x -idq "$input_file" "$output_dir/"
        ;;
    *)
        echo "Error: Unsupported file type '$mime_type'"
        exit 1
        ;;
esac

echo "Extraction completed: $output_dir"
