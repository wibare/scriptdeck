#!/bin/bash

set -euo pipefail

LINKS_DIR="$HOME/.scriptdeck-links"
LINKS_FILE="$LINKS_DIR/links.md"

mkdir -p "$LINKS_DIR"
touch "$LINKS_FILE"

bold=$(tput bold)
reset=$(tput sgr0)
cyan=$(tput setaf 6)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
gray=$(tput setaf 7)

usage() {
    echo "Usage:"
    echo "  $0 add <url> [title] [--tags tag1,tag2]"
    echo "  $0 list"
    echo "  $0 search <keyword>"
    echo "  $0 open <number>"
    echo "  $0 edit <number>"
    echo "  $0 delete <number>"
    exit 1
}

add_link() {
    local url="$1"
    local title="${2:-$url}"
    shift 2 || true
    local tags=""

    if [[ "${1:-}" == "--tags" && -n "${2:-}" ]]; then
        tags="@${2//,/ @}"
    fi

    local date="$(date '+%Y-%m-%d %H:%M')"
    echo "- [$title]($url) $tags" >> "$LINKS_FILE"
    echo "  Saved: $date"         >> "$LINKS_FILE"
    echo ""                      >> "$LINKS_FILE"
    echo "Link saved."
}

list_links() {
    awk -v b="$bold" -v r="$reset" -v c="$cyan" -v g="$green" -v y="$yellow" -v gr="$gray" '
        BEGIN { n = 0 }
        /^\- \[(.*)\]\((.*)\)(.*)$/ {
            n++
            title = gensub(/^\- \[(.*)\]\(.*\).*/, "\\1", "g")
            url = gensub(/^\- \[.*\]\((.*)\).*/, "\\1", "g")
            tags = gensub(/^\- \[.*\]\(.*\) *(.*)/, "\\1", "g")
            getline date
            print b "[" n "]" r " " c title r
            print "    " g url r
            if (tags != "") print "    Tags: " y tags r
            print "    Saved: " gr gensub(/^  Saved: /, "", "g", date) r
            print ""
        }
    ' "$LINKS_FILE"
}

search_links() {
    local keyword="$1"
    awk -v kw="$keyword" -v b="$bold" -v r="$reset" -v c="$cyan" -v g="$green" -v y="$yellow" -v gr="$gray" '
        BEGIN { n = 0; IGNORECASE = 1 }
        /^\- \[(.*)\]\((.*)\)(.*)$/ {
            if ($0 ~ kw) {
                n++
                title = gensub(/^\- \[(.*)\]\(.*\).*/, "\\1", "g")
                url = gensub(/^\- \[.*\]\((.*)\).*/, "\\1", "g")
                tags = gensub(/^\- \[.*\]\(.*\) *(.*)/, "\\1", "g")
                getline date
                print b "[" n "]" r " " c title r
                print "    " g url r
                if (tags != "") print "    Tags: " y tags r
                print "    Saved: " gr gensub(/^  Saved: /, "", "g", date) r
                print ""
            } else {
                getline
            }
        }
    ' "$LINKS_FILE"
}

open_link() {
    local number="$1"
    local url=$(awk -v n="$number" '
        /^\- \[.*\]\((.*)\)/ {
            count++
            if (count == n) {
                match($0, /\(.*\)/)
                url = substr($0, RSTART+1, RLENGTH-2)
                print url
                exit
            }
        }
    ' "$LINKS_FILE")

    if [[ -z "$url" ]]; then
        echo "No link found with number $number."
        exit 1
    fi

    xdg-open "$url" >/dev/null 2>&1 &
}

delete_link() {
    local number="$1"
    local total_lines
    total_lines=$(wc -l < "$LINKS_FILE")

    local start_line=$(( (number - 1) * 3 + 1 ))

    if [[ $start_line -gt $total_lines || $number -lt 1 ]]; then
        echo "Invalid link number: $number"
        exit 1
    fi

    sed -i "${start_line},$((start_line+2))d" "$LINKS_FILE"
    echo "Link #$number deleted."
}

edit_link() {
    local number="$1"
    local start_line=$(( (number - 1) * 3 + 1 ))

    local original_line
    original_line=$(sed -n "${start_line}p" "$LINKS_FILE")

    local title=$(echo "$original_line" | sed -E 's/^- \[(.*)\]\(.*\).*/\1/')
    local url=$(echo "$original_line" | sed -E 's/^- \[.*\]\((.*)\).*/\1/')
    local tags=$(echo "$original_line" | sed -E 's/^- \[.*\]\(.*\) *(.*)/\1/')

    echo "Editing link #$number"
    read -rp "Title [$title]: " new_title
    read -rp "URL [$url]: " new_url
    read -rp "Tags (space-separated) [$tags]: " new_tags

    new_title="${new_title:-$title}"
    new_url="${new_url:-$url}"
    new_tags="${new_tags:-$tags}"

    local date="$(date '+%Y-%m-%d %H:%M')"
    sed -i "${start_line}s|.*|- [$new_title]($new_url) $new_tags|" "$LINKS_FILE"
    sed -i "$((start_line + 1))s|.*|  Saved: $date|" "$LINKS_FILE"

    echo "Link #$number updated."
}

case "${1:-}" in
    add)
        [[ $# -ge 2 ]] || usage
        add_link "$2" "${3:-}" "${4:-}" "${5:-}"
        ;;
    list)
        list_links
        ;;
    search)
        [[ $# -eq 2 ]] || usage
        search_links "$2"
        ;;
    open)
        [[ $# -eq 2 ]] || usage
        open_link "$2"
        ;;
    delete)
        [[ $# -eq 2 ]] || usage
        delete_link "$2"
        ;;
    edit)
        [[ $# -eq 2 ]] || usage
        edit_link "$2"
        ;;
    *)
        usage
        ;;
esac
