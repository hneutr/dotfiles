export DOTDIR=$HOME/dotfiles

export XDG_CONFIG_HOME=$HOME/.config

export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL=

[[ "$(uname)" = "Darwin" ]] && source $DOTDIR/shell/exports.macos.sh

source $DOTDIR/shell/exports.python.sh

source $DOTDIR/shell/exports.nvim.sh
