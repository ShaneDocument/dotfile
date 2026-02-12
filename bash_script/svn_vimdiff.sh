#!/bin/bash
#
# svnvimdiff.sh
# Diff the given file using vimdiff with syntax highlighting.
#
# Usage:
#   ./svnvimdiff.sh <File Path> [rev1] [rev2]
#
# Examples:
#   ./svnvimdiff.sh main.c           # Diff BASE vs working copy
#   ./svnvimdiff.sh main.c 1234      # Diff r1234 vs working copy
#   ./svnvimdiff.sh main.c 1234 1250 # Diff r1234 vs r1250

# --- Check arguments ---
if [[ $# -lt 1 || $# -gt 3 ]]; then
    echo "Usage: $0 <File Path> [rev1] [rev2]"
    echo "Example: $0 main.c           # Diff BASE vs working copy"
    echo "         $0 main.c 1234      # Diff r1234 vs working copy"
    echo "         $0 main.c 1234 1250 # Diff r1234 vs r1250"
    exit 1
fi

FILE="$1"
REV1="${2:-BASE}"
REV2="$3"

# --- Check if the file is under SVN control ---
if ! svn info "$FILE" > /dev/null 2>&1; then
    echo "Error: $FILE hasn't been managed by SVN."
    exit 1
fi

# --- Determine file extension for syntax highlighting ---
EXT="${FILE##*.}"   # 例如 main.c → c, header.h → h

# --- Temporary file paths ---
TMP1=$(mktemp "/tmp/svnvimdiff_${REV1}_XXXX.$EXT")
TMP2=""
CLEANUP_FILES=("$TMP1")

# --- Function for cleanup ---
cleanup() {
    rm -f "${CLEANUP_FILES[@]}"
}
trap cleanup EXIT

# --- Prepare comparison files ---
if [[ -z "$REV2" ]]; then
    # Compare single revision (or BASE) vs working copy
    svn cat -r "$REV1" "$FILE" > "$TMP1"
    vimdiff "$TMP1" "$FILE"
else
    # Compare between two revisions
    TMP2=$(mktemp "/tmp/svnvimdiff_${REV2}_XXXX.$EXT")
    CLEANUP_FILES+=("$TMP2")
    svn cat -r "$REV1" "$FILE" > "$TMP1"
    svn cat -r "$REV2" "$FILE" > "$TMP2"
    vimdiff "$TMP1" "$TMP2"
fi
