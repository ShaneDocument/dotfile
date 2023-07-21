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
read -rsp $'This install script will delete your .vim, .vimrc and .tmux.conf. Press y to continue....\n' -n1 READ
if [ "$READ" != 'y' ]; then
    echo "**** STOP do this. ****"
    exit 1
fi

# Copy vim configuration...
echo "Copy vim configuration..."
cp -r -v ./.vim $HOME
cp -r -v ./.vimrc $HOME
# Copy tmux configuration...
echo "Copy tmux configuration..."
cp -r -v ./.tmux.conf $HOME
cp -r -v ./.tmux_theme $HOME
# Copy cscope build script...
echo "Copy cscope build script..."
mkdir ~/bash_script
cp -v ./build_cscope.sh ~/bash_script
# Copy .clang_format...
echo "Copy .clang_format..."
cp -r -v ./.clang_format $HOME

# Setting bash_profile...
echo "Setting bash_profile..."
echo "alias tmux=\"TERM=screen-256color-bce tmux\"" | tee -a ~/.bash_profile
echo "alias :q=\"exit\"" | tee -a ~/.bash_profile
echo "export TERM=\"xterm-256color\"" | tee -a ~/.bash_profile
check_folder_exist "~/bin"
if [ $? -eq 0 ]; then
    mkdir "~/bin"
fi
echo "PATH=\$HOME//bin:\$PATH" | tee -a ~/.bash_profile
