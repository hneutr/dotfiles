export THIS_DIR="$(dirname -- $(readlink -f "$0"))"
ln -sf $THIS_DIR $HOME/.zsh
ln -sf $THIS_DIR/zshrc $HOME/.zshrc
ln -sf $THIS_DIR/zshenv $HOME/.zshenv
