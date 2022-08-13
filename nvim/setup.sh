function install_nvim_appimage() {
    local NVIM_APP_DIR=$HOME/dotfiles/nvim/app

    [ ! -d $NVIM_APP_DIR ] && mkdir $NVIM_APP_DIR

    local NVIM_VERSION="0.7.2"

    local APP_FILE=$NVIM_APP_DIR/nvim.appimage
    local URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"

    curl $URL --output ${APP_FILE}

    chmod u+x $APP_FILE
    $APP_FILE --appimage-extract
}

[ ! $(command -v nvim) ] && install_nvim_appimage
