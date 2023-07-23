#!/bin/bash
# Program:
#   This program will install the most of the environment settings
check_folder_exist() {
    BASENAME=$(basename $1)
    if [ ! -d $1 ]; then
        return 1
    fi
    return 0
}

mv_files() {
    filename=$1
    dest=$2
    full_path=$(realpath "$dest")
    printf "Move [%s] to [%s]...\n" "$filename" "$full_path"
    mv $filename $full_path/
}

backup_files() {
    filename=$1
    backup_folder=$2
    mv_files $filename $backup_folder
}

copy_files() {
    filename=$1
    dest=$2
    full_path=$(realpath "$dest")
    printf "Copy [%s] to [%s]...\n" "$filename" "$full_path"
    cp -r -v ./$filename $dest
}

log_file="./build_log"

exec > >(tee "$log_file") 2>&1

files=(".vim" ".vimrc" ".tmux.conf" ".tmux_theme" ".clang-format" "bash_script" ".bash_profile" ".bash_commons")
backup_folder="./bak"

echo "These files:"
for file in ${files[@]}; do
    printf "%s\n" "$file"
done

read -rsp $'$will be backed up before installing. Still Install?[Y/N]\n' -n1 READ
if [ "$READ" != 'y' ] && [ "$READ" != 'Y' ]; then
    echo "**** STOP doing this. ****"
    exit 1
fi

check_folder_exist $backup_folder
if [ $? -eq 1 ]; then
    echo "Start backing up..."
    mkdir $backup_folder
    for file in ${files[@]}; do
        src_file=$HOME/$file
        backup_files $src_file $backup_folder
    done
    echo "Finish backing up."
fi


for file in ${files[@]}; do
    copy_files $file $HOME
done
# Setting bash_profile...
echo "Setting bash_profile..."
if grep -q "bash_commons" "$HOME/.bash_profile"; then
    echo "Already finish setting .bash_profile."
else
    echo "source $HOME/.bash_commons" | tee -a ~/.bash_profile
    check_folder_exist "~/bin"
    if [ $? -eq 1 ]; then
        mkdir ~/bin
    fi
fi

