#!/bin/bash

set -euo pipefail

# Check if pdfunite is available
if ! command -v pdfunite >/dev/null 2>&1; then
    echo "Error: 'pdfunite' is not installed." >&2
    echo "Install it with: sudo apt install poppler-utils" >&2
    exit 1
fi

# Show usage
usage() {
    echo "Usage: $0 input1.pdf [input2.pdf ...] output.pdf"
    echo "Example: $0 file1.pdf file2.pdf merged.pdf"
    exit 1
}

# Check arguments
if [[ "$#" -lt 3 ]]; then
    echo "Error: At least two input files and one output file are required." >&2
    usage
fi

# Separate input files and output file
output="${@: -1}"  # Last argument is output
inputs=("${@:1:$#-1}")  # All but last are inputs

# Check that input files exist
for input in "${inputs[@]}"; do
    if [[ ! -f "$input" ]]; then
        echo "Error: File not found: $input" >&2
        exit 1
    fi
    if [[ "${input##*.}" != "pdf" ]]; then
        echo "Error: Invalid file type: $input (only PDF files allowed)" >&2
        exit 1
    fi
done

# Check output extension
if [[ "${output##*.}" != "pdf" ]]; then
    echo "Error: Output file must have a .pdf extension." >&2
    exit 1
fi

# Prevent overwriting existing files without confirmation
if [[ -e "$output" ]]; then
    read -rp "Warning: '$output' already exists. Overwrite? [y/N]: " confirm
    case "$confirm" in
        [yY][eE][sS]|[yY]) ;;
        *) echo "Aborted." ; exit 1 ;;
    esac
fi

# Merge PDFs
pdfunite "${inputs[@]}" "$output"

echo "Successfully merged ${#inputs[@]} file(s) into: $output"

