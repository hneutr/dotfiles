export THIS_DIR="$(dirname -- $(readlink -f "$0"))"
ln -sf $THIS_DIR $XDG_CONFIG_HOME/matplotlib
