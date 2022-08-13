export IPYTHON_PROFILE_DIR=$HOME/.ipython/profile_default

[ ! -d $IPYTHON_PROFILE_DIR ] && ipython profile create

ln -s $DOTDIR/python/ipython/ipython_config.py $IPYTHON_PROFILE_DIR/ipython_config.py
