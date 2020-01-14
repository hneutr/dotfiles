#!/usr/bin/env bash

# list the dotfiles
declare -a dots=(
    "bin"
    "config"
    "gitconfig"
    "zplug"
    "zsh"
    "zshrc"
    "zshenv"
)

export DOTFILES=$HOME/dotfiles

# symlink them
for dot in "${dots[@]}"; do
    ln -sf $DOTFILES/$dot $HOME/.$dot
done

