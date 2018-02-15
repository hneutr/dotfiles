#!/usr/bin/env bash

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

# install all that good jazz
xargs brew install < brewed.txt
