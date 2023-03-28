function init() {
    local IPYTHON_PROFILE_DIR=$HOME/.ipython/profile_default

    [ ! -d $IPYTHON_PROFILE_DIR ] && ipython profile create

    ln -sf "$(dotpath python/ipython/ipython_config.py)" $IPYTHON_PROFILE_DIR/ipython_config.py
}
init
