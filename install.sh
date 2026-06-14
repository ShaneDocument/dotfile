#!/bin/bash
# Program:
#   This program will install the most of the environment settings

#!/bin/bash

# Function to install Node.js v22 using official NodeSource binaries
install_nodejs_v22() {
    echo "=================================================="
    echo " Checking and installing Node.js v22 Setup...     "
    echo "=================================================="

    # 1. Check if Node.js v22 is already installed to skip redundant work
    if command -v node &> /dev/null; then
        local current_version=$(node -v | sed 's/v//')
        local major_version=$(echo "$current_version" | cut -d. -f1)
        
        if [ "$major_version" -eq 22 ]; then
            echo "✅ Node.js v22 is already installed (Detected: v${current_version}). Skipping installation."
            return 0
        else
            echo "⚠️ Found Node.js version v${current_version}, but Node.js v22 is required."
            echo "Proceeding to upgrade/overwrite with version 22..."
        fi
    fi

    # 2. Check for 'curl' (critical dependency for adding the repo source)
    if ! command -v curl &> /dev/null; then
        echo "📦 'curl' is missing. Installing curl first..."
        sudo apt-get update && sudo apt-get install -y curl
    fi

    # 3. Verify user has sudo permissions before attempting installation
    if ! sudo -v &> /dev/null; then
        echo "❌ Error: Root privileges are required to configure apt repositories."
        echo "Please re-run this installer script as a user with sudo access."
        return 1
    fi

    # 4. Add NodeSource repository configuration
    echo "🌐 Downloading and executing NodeSource setup for Node v22.x..."
    if curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -; then
        echo "✅ NodeSource repository successfully integrated."
    else
        echo "❌ Error: Failed to download or execute NodeSource repository script."
        return 1
    fi

    # 5. Run the installation package command
    echo "📦 Running apt-get install for nodejs..."
    if sudo apt-get install -y nodejs; then
        # Double check the installation was successful
        local final_version=$(node -v)
        echo "🚀 Node.js has been successfully installed! Version: $final_version"
        return 0
    else
        echo "❌ Error: Apt-get failed to finish installing nodejs."
        return 1
    fi
}

# --- Example of running the script pipeline ---



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
    cp -r -f $filename $dest
}



log_file="./build_log"
files=(".vim" ".vimrc" ".tmux.conf" ".tmux_theme" ".clang-format" "bash_script" ".bash_commons" ".bash_prompt" ".bash_keybinds")
backup_folder="$HOME/dotfile_bak"
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


# {{{ Backup Files
echo "********************************** Start backup checking... **********************************"

mkdir $backup_folder
for file in ${files[@]}; do
    src_file=$HOME/$file
    if [[ -e "$file" ]]; then
        diff_files_folders $src_file $file
        if [ $? -ne 0 ]; then
            echo "Start copying files..."
            copy_files $src_file $backup_folder
            backup_check="NeedCheck"
        fi
    fi
done

if [[ "$backup_check" == "NeedCheck" ]]; then
    echo "********************************** Finish backup files. **********************************"
    for file in ${files[@]}; do
        # Check for the backup
        src_file=$HOME/$file
        bak_file=$backup_folder/$file
        if [[ -e "$src_file" ]]; then
            if [[ -e "$bak_file" ]]; then
                diff_files_folders $src_file $bak_file
                diff_result=$(diff -r "$src_file" "$bak_file")
                if [ $? -eq 0 ]; then
                    echo "Backup of '$src_file' was successful. Files are identical."
                    backup_check="Pass"
                else
                    echo "Backup of '$src_file' failed. Files are different."
                    exit 2
                fi
            fi
        fi
    done
fi
# Backup Files }}}


# {{{ Remove Files
echo "********************************** Removing files... **********************************"
for file in ${files[@]}; do
    rm -rf $HOME/$file
done
# Remove Files }}}


# {{{ Installing Files
# install vim coc.vim and tagbar
git submodule update --init --recursive
echo "********************************** Installing files... **********************************"
for file in ${files[@]}; do
    copy_files ./$file $HOME
done
echo "********************************** Finish Installing files **********************************"

echo "********************************** Setting up vim... **********************************"
# Ensure the system package lists are updated before doing checks
echo "Updating local apt package list..."
sudo apt-get update -y
# install nodejs for coc.
if ! install_nodejs_v22; then
    echo "❌ Node.js initialization script failed. Terminating deployment loop."
    exit 1
fi

vim -c "helptags ~/.vim/pack/coc/start/coc.nvim/doc/ | q"

echo "********************************** Finish Setting up vim **********************************"
# Installing Files }}}


# Check the file is install or not
for file in ${files[@]}; do
    diff_files_folders ./$file $HOME/$file
    if [ $? -eq 1 ]; then
        install_check="Failed"
    fi
done

# Setting bashrc...
echo "********************************** Setting bashrc... **********************************"
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
