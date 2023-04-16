export THIS_DIR="$(dirname -- $(readlink -f "$0"))"
ln -sf $THIS_DIR $HOME/.config/hnetxt
