export PYTHON_DOTS_DIR=$HOME/dotfiles/python
export MPL_SETUP_PATH=$PYTHON_DOTS_DIR/matplotlib/setup.sh
export IPYTHON_SETUP_PATH=$PYTHON_DOTS_DIR/ipython/setup.sh

chmod +x $MPL_SETUP_PATH && $MPL_SETUP_PATH
chmod +x $IPYTHON_SETUP_PATH && $IPYTHON_SETUP_PATH
