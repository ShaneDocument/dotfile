#!/bin/bash
# Program:
# cscope_build.sh [rm] folder folder ....
# @rm: It's an optional flag for delete the cscope file
# @folder: folder to find c and header files.

check_file_exist() {
    FULLPATH="$1"
    BASENAME=$(basename "$FULLPATH")
    if [ ! -f "$FULLPATH" ]; then
        printf "%s: not found\n" "$BASENAME"
        exit 1
    fi
    printf "[%s] :\n%s\n\n" "$BASENAME" "$FULLPATH"
}

check_folder_exist() {
    FULLPATH="$1"
    BASENAME=$(basename "$FULLPATH")
    if [ ! -d "$FULLPATH" ]; then
        printf "%s: not found or not a folder\n" "$BASENAME"
        exit 1
    fi
    printf "[%s] :\n%s\n\n" "$BASENAME" "$FULLPATH"
}

PWD=$(pwd -P)

if [ $1 == "-rm" ]
then
    $(rm $PWD/cscope.* > /dev/null 2> /dev/null)
fi

if [ $1 == "-u" ] || [ $1 == "-U" ] || [ $1 == "--update" ]
then
    cscope -Rqbvk
    exit 0
fi

cscope_file_path=$PWD/cscope.files
cscope_logs=$PWD/cscope.log
$(rm "$cscope_file_path")
$(rm "$cscope_logs")
for folder in "$@"
do
    if [ $folder == "-rm" ]
    then
        continue
    fi
    folder=$PWD/$folder
    check_folder_exist "$folder"
    echo $folder >> cscope.log
    find "$folder" \
        \( -name build -o -name build_internal \) -prune -o \
        -name "*.cfg" -o \
        -name "*.c" -o \
        -name "*.h" -o \
        -name "*.json" -o \
        -name "*.cpp" -o \
        -name "*.hpp" \
        | awk '{print "\""$0"\""}' >> "$cscope_file_path"
done
check_file_exist "$cscope_file_path"
cscope -Rqbvk -i "$cscope_file_path"
