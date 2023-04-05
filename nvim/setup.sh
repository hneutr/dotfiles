function install_nvim_appimage() {
    mkdir -p $NVIM_APP_DIR

    curl $NVIM_APPIMAGE_URL --output ${NVIM_APP_FILE}

    chmod u+x $NVIM_APP_FILE
    $NVIM_APP_FILE --appimage-extract
}

[ ! $(command -v nvim) ] && install_nvim_appimage

export THIS_DIR="$(dirname -- $(readlink -f "$0"))"
ln -sf $THIS_DIR $XDG_CONFIG_HOME/nvim
