export MATPLOTLIB_DIR=$XDG_CONFIG_HOME/matplotlib

[ ! -d $MATPLOTLIB_DIR ] && mkdir $MATPLOTLIB_DIR

ln -s $DOTDIR/python/matplotlib/matplotlibrc $MATPLOTLIB_DIR/matplotlibrc
ln -s $DOTDIR/python/matplotlib/default-matplotlibrc $MATPLOTLIB_DIR/default-matplotlibrc
