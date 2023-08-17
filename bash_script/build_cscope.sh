#!/bin/bash
# Program:
# cscope_build.sh [rm] folder folder ....
# @rm: It's an optional flag for delete the cscope file
# @folder: folder to find c and header files.

check_file_exist() {
    BASENAME=$(basename $1)
    if [ ! -f $1 ]; then
        printf "%s: not found\n" "$BASENAME"
        exit 1
    fi
    printf "[%s] :\n%s\n\n" "$BASENAME" "$1"
}

check_folder_exist() {
    BASENAME=$(basename $1)
    if [ ! -d $1 ]; then
        printf "%s: not found or not a folder\n" "$BASENAME"
        exit 1
    fi
    printf "[%s] :\n%s\n\n" "$BASENAME" "$1"
}

PWD=$(pwd -P)

if [ $1 == "rm" ]
then
    $(rm $PWD/cscope.* > /dev/null 2> /dev/null)
fi

cscope_file_path=$PWD/cscope.files
cscope_logs=$PWD/cscope.log
$(rm $cscope_file_path > /dev/null 2> /dev/null)
$(rm $cscope_logs > /dev/null 2> /dev/null)
for folder in "$@"
do
    if [ $folder == "rm" ]
    then
        continue
    fi
    folder=$PWD/$folder
    check_folder_exist $folder
    echo $folder >> cscope_logs
    find "$folder" \( -name build -o -name build_internal \) -prune -o -name "*.cfg" -o -name "*.c" -o -name "*.h" -o -name "*.json" >> $PWD/cscope.files
done
check_file_exist $cscope_file_path
cscope -Rqbvk
