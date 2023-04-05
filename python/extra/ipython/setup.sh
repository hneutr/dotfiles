export THIS_DIR="$(dirname -- $(readlink -f "$0"))"
export IPYTHON_PROFILE_DIR=$HOME/.ipython/profile_default

[ ! -d $IPYTHON_PROFILE_DIR ] && ipython profile create
ln -sf "$THIS_DIR/ipython_config.py" $IPYTHON_PROFILE_DIR/ipython_config.py
