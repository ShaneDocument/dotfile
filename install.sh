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
# Install Python
# cd Python-3.11.1
# ./configure --prefix=$HOME/python --enable-optimizations --enable-shared
# make -j 8
# make install -j 8
# cd ..
# ls
# C_INCLUDE_PATH=$HOME/Python/include/python3.11
# export C_INCLUDE_PATH

# PATH=$HOME/python/bin:${PATH}
# export PATH
# # Install CMake
# cd CMake
# ./bootstrap --prefix=$HOME/local/bin/CMake
# make -j 8
# make install -j 8
# cd ..
# ls
# PATH=$HOME/local/bin/CMake/bin:${PATH}
# export PATH
