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

check_file_exist() {
    BASENAME=$(basename $1)
    if [ ! -f $1 ]; then
        return 1
    fi
    return 0
}

diff_files_folders() {
    file1=$1
    file2=$2
    diff_result=$(diff -r "$file1" "$file2")
    if [ -z "$diff_result" ]; then
        echo "Files(folders) are identical. ([$file1] <-> [$file2])"
        return 0
    else
        echo "Files(folders) are different. ([$file1] <-> [$file2])"
        return 1
    fi
}
mv_files() {
    filename=$1
    dest=$2
    full_path=$(realpath "$dest")
    printf "Move [%s] to [%s]...\n" "$filename" "$full_path"
    mv $filename $full_path/
}

copy_files() {
    filename=$1
    dest=$2
    full_path=$(realpath "$dest")
    printf "Copy [%s] to [%s]...\n" "$filename" "$full_path"
    cp -r -v $filename $dest
}



log_file="./build_log"
files=(".vim" ".vimrc" ".tmux.conf" ".tmux_theme" ".clang-format" "bash_script" ".bash_commons" ".bash_prompt")
backup_folder="./bak"
clean_check="No need"
backup_check="No need"
install_check="Pass"
bashrc_check="Pass"


if [ "$1" == "clean" ] || [ "$1" == "c" ] ; then
    echo "*************************************************************************"
    echo "Warning: Clean flag is set. Bakeup folder and build logs will be removed."
    echo "*************************************************************************"
fi
echo "These files:"
for file in ${files[@]}; do
    printf "%s\n" "$file"
done

read -rsp $'will be backed up before installing. Still Install? [Y/N]\n' -n1 READ
if [ "$READ" != 'y' ] && [ "$READ" != 'Y' ]; then
    echo "**** STOP doing this. ****"
    exit 1
fi

if [ "$1" == "clean" ] || [ "$1" == "c" ] ; then
    echo "Remove $backup_folder and $log_file"
    rm -rf $backup_folder
    rm -rf $log_file
    clean_check="Pass"
fi

exec > >(tee "$log_file") 2>&1

check_folder_exist $backup_folder
if [ $? -eq 1 ]; then
    echo "Start backing up..."
    mkdir $backup_folder
    echo "Start copying files..."
    for file in ${files[@]}; do
        src_file=$HOME/$file
        copy_files $src_file $backup_folder
    done
    echo "Finish copying files."
    for file in ${files[@]}; do
        src_file=$HOME/$file
        bak_file=$backup_folder/$file
        diff_files_folders $src_file $bak_file
        diff_result=$(diff -r "$src_file" "$bak_file")
        if [ $? -eq 0 ]; then
            echo "Backup of '$src_file' was successful. Files are identical."
        else
            echo "Backup of '$src_file' failed. Files are different."
            # exit 2
        fi
    done
    backup_check="Pass"
    echo "Finish backing up."
fi

echo "Removing files..."
for file in ${files[@]}; do
    rm -rf $HOME/$file
done

for file in ${files[@]}; do
    copy_files ./$file $HOME
done
# Check the file is install or not
for file in ${files[@]}; do
    diff_files_folders ./$file $HOME/$file
    if [ $? -eq 1 ]; then
        install_check="Failed"
    fi
done

# Setting bashrc...
echo "Setting bashrc..."
if grep -q "bash_commons" "$HOME/.bashrc"; then
    echo "Already finish setting .bashrc."
else
    echo "source $HOME/.bash_commons" | tee -a ~/.bashrc
    check_folder_exist "~/bin"
    if [ $? -eq 1 ]; then
        mkdir ~/bin
    fi
    # Check bashrc
    if grep -q "bash_commons" "$HOME/.bashrc"; then
        bashrc_check="Pass"
    fi
fi

# Append timestamp in .bash_commons
current_time=$(date +'%H:%M:%S')
echo "# timestamp: $current_time" | tee -a ~/.bash_commons


echo "********************************** Build Result ************************************"
echo "Clean: $clean_check"
echo "Backup: $backup_check"
echo "Install: $install_check"
echo "Bashrc setup: $bashrc_check"
echo "************************************************************************************"
