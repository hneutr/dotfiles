#!/usr/bin/env bash

################################################################################
# Assumptions:
# - this script is being run out of $HOME/dotfiles
# - curl is installed
################################################################################
export DOTFILES=$HOME/dotfiles

# steps:
# 1. download brew
#   - install brew stuff
# 2. symlink stuff
# 3. set up vim plugins?

# 1. Set up brew
exec $DOTFILES/brewstrap.sh

# 2. Link dotfiles
exec $DOTFILES/dotstrap.sh

# install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# setup vim plugins?
