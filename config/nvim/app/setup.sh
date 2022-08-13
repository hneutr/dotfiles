function install_app() {
    local NVIM_VERSION="0.7.2"
    local APP_DIR=$HOME/dotfiles/config/nvim/app

    local APP_FILE=$APP_DIR/nvim.appimage
    local URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"

    curl $URL --output ${APP_FILE}

    chmod u+x $APP_FILE
    $APP_FILE --appimage-extract
    ./squashfs-root/usr/bin/nvim
}

install_app
