#!/bin/bash

IPADDR=$1
LOGIN_USER="my_remote"
TARGET_PATH="~/WinSCP"

shift

sshpass -p "$LOGIN_PASSWD" ssh -o StrictHostKeyChecking=no "$LOGIN_USER@$IPADDR" "mkdir -p $TARGET_PATH"

for FILE in "$@"; do
    if [ "$FILE" == "." ]; then
        CURRENT_DIR_NAME=$(basename "$(pwd)")
        echo "Transfer data to remote (rsync): $CURRENT_DIR_NAME"
        rsync -avzp --delete --exclude='cscope.*' --exclude='.svn/' --exclude='android/' \
            "$FILE" "$LOGIN_USER@$IPADDR:$TARGET_PATH/$CURRENT_DIR_NAME"
    else
        echo "Transfer data to remote (rsync): $FILE"
        rsync -avzp --delete --exclude='cscope.*' --exclude='.svn/' --exclude='android/' \
            "$FILE" "$LOGIN_USER@$IPADDR:$TARGET_PATH"
    fi
done
