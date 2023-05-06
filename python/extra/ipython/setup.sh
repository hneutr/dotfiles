export IPYTHON_DOTFILES=$DOTFILES/python/extra/ipython
export IPYTHON_PROFILE_DIR=$HOME/.ipython/profile_default

[ ! -d $IPYTHON_PROFILE_DIR ] && ipython profile create
rm $IPYTHON_PROFILE_DIR/ipython_config.py
ln -s "$IPYTHON_DOTFILES/ipython_config.py" $IPYTHON_PROFILE_DIR/ipython_config.py
