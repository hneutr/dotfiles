export THIS_DIR="$(dirname -- $(readlink -f "$0"))"

ln -sf $THIS_DIR $HOME/.bash
ln -sf $THIS_DIR/bash_profile.sh $HOME/.bash_profile
ln -sf $THIS_DIR/bashrc.sh $HOME/.bashrc
