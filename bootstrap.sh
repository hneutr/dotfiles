#!/usr/bin/env bash

################################################################################
# Assumptions:
# - this script is being run out of $HOME/dotfiles
# - curl is installed
################################################################################
export $DOTFILES=$HOME/dotfiles

# steps:
# 1. download brew
#   - install brew stuff
# 2. symlink stuff
# 3. set up vim plugins?

if [ ! -f "`which brew`" ]; then
    # install brew if it isn't installed yet
    if [ "$(uname)" == "Darwin" ]; then
        # brew if osx
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # linuxbrew if linux
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    fi
fi

xargs brew install < brewed.txt

# dotfiles and dirs to symlink
local dots=(
    "bin",
    "config",
    "gitconfig",
    "zplug",
    "zsh",
    "zshrc",
)

# symlink them
for $dot in $dots; do
    ln -sf $DOTFILES/$dot $HOME/.$dot
done

# install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# setup vim plugins?
