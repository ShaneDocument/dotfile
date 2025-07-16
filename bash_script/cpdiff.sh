#!/bin/bash
# Program:
# cpdiff.sh src/ dest/
# @src: The source folder
# @dest: The destination folder. If it's not exist, it will be created

set -e

# Check the args
if [ $# -ne 2 ]; then
    echo "Usage: $0 <src_dir> <dest_dir>"
    exit 1
fi

src="$1"
dest="$2"

# Check the src is exist or not
if [ ! -d "$src" ]; then
    echo "Error: '$src' is not exist"
    exit 2
fi

# If dest is not exist, create it.
if [ ! -d "$dest" ]; then
    echo "Destination '$dest' is not exist. creating ..."
    mkdir -p "$dest"
fi

# excluding files
EXCLUDES=(
    "*.cscope*"
    "*.tmp"
    "*.swp"
    ".git/"
    ".svn/"
)

# Convert to rsync pattern
EXCLUDE_PARAMS=()
for pattern in "${EXCLUDES[@]}"; do
    EXCLUDE_PARAMS+=(--exclude="$pattern")
done

echo "Start..."
echo "Source：$src"
echo "Destination：$dest"

rsync -av --update "${EXCLUDE_PARAMS[@]}" "$src/" "$dest/" \
    | tee /tmp/rsync_sync_log.txt

echo
echo "✅ Finish. The created files / folders："
grep -E '^\.\/' /tmp/rsync_sync_log.txt || echo "（Not change）"
