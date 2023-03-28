function install_nvim_appimage() {
    mkdir -p $NVIM_APP_DIR

    curl $NVIM_APPIMAGE_URL --output ${NVIM_APP_FILE}

    chmod u+x $NVIM_APP_FILE
    $NVIM_APP_FILE --appimage-extract
}

[ ! $(command -v nvim) ] && install_nvim_appimage

ln -sf "$(dotpath nvim)" $XDG_CONFIG_HOME/nvim
