export DOTDIR=$HOME/dotfiles

export XDG_CONFIG_HOME=$HOME/.config

[[ "$(uname)" = "Darwin" ]] && source $DOTDIR/shell/exports.macos.sh

source $DOTDIR/shell/exports.python.sh

source $DOTDIR/shell/exports.nvim.sh
