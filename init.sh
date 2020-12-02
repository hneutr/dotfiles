################################################################################
# Assumptions:
# - this script is being run out of $HOME/dotfiles
# - curl is installed
################################################################################
export DOTFILES=$HOME/dotfiles

################################################################################
# 1. link things
################################################################################
ln -s $DOTFILES/bin $HOME/.bin
ln -s $DOTFILES/config $HOME/.config
ln -s $DOTFILES/gitconfig $HOME/.gitconfig
ln -s $DOTFILES/zshrc $HOME/.zshrc
ln -s $DOTFILES/zshenv $HOME/.zshenv
ln -s $DOTFILES/bashrc $HOME/.bashrc
ln -s $DOTFILES/bash_profile $HOME/.bash_profile

################################################################################
# 2. install vim plug
################################################################################
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Set up brew?
# download nvim?
# setup vim plugins?
