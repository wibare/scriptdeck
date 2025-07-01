#!/bin/bash

set -euo pipefail

# Check for required argument
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file_path="$1"

# Check if file exists and is regular
if [[ ! -f "$file_path" ]]; then
    echo "Error: '$file_path' is not a regular file or does not exist."
    exit 1
fi

# Resolve absolute path
abs_path="$(realpath "$file_path")"

# Basic info
echo "File: $abs_path"
echo "Size: $(du -h "$file_path" | cut -f1)"
echo "MIME type: $(file --mime-type -b "$file_path")"
echo "Encoding: $(file --mime-encoding -b "$file_path")"
echo "Permissions: $(stat -c '%A (%a) - Owner: %U:%G' "$file_path")"
echo "Timestamps:"
echo "  Modified : $(stat -c '%y' "$file_path")"
echo "  Accessed : $(stat -c '%x' "$file_path")"
echo "  Changed  : $(stat -c '%z' "$file_path")"
echo "Inode: $(stat -c '%i' "$file_path")"
echo "Hard links: $(stat -c '%h' "$file_path")"

# Hashes
echo "MD5:    $(md5sum "$file_path" | awk '{print $1}')"
echo "SHA1:   $(sha1sum "$file_path" | awk '{print $1}')"
echo "SHA256: $(sha256sum "$file_path" | awk '{print $1}')"

# If text, show line and word counts
mime_type=$(file --mime-type -b "$file_path")
if [[ "$mime_type" == text/* ]]; then
    echo "Line count: $(wc -l < "$file_path")"
    echo "Word count: $(wc -w < "$file_path")"
fi
