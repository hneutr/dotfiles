source $HOME/dotfiles/shell/util.sh

export SHELL_NAME="$(basename $SHELL)"

source "$(dotpath os/exports.sh)"
source "$(dotpath python/exports.sh)"
source "$(dotpath nvim/exports.sh)"
