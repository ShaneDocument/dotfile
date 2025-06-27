#!/bin/bash

# svnvimdiff.sh
# Diff the given file.
# @1: The file
# @2: Revision (Optional)


# check the arguments
if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <File Path> [revision]"
  echo "Example: $0 main.c           # Diff BASE vs working copy"
  echo "         $0 main.c 1234      # Diff r1234 vs working copy"
  exit 1
fi

FILE="$1"
REV="${2:-BASE}"

# Check if the file has been managed by svn or not.
svn info "$FILE" > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Error: $FILE hasn't been managed by SVN."
  exit 1
fi

# Get the version of file and diff by vimdiff
vimdiff <(svn cat -r "$REV" "$FILE") "$FILE"
