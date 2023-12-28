[ -z "$NVIM_PATH" ] && export NVIM_PATH=$(which nvim)

export NVIM_VERSION="0.9.0"
export NVIM_APP_DIR=$DOTFILES/nvim/app
export NVIM_APP_FILE=$DOTFILES/nvim/nvim.appimage
export NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
export NVIM_PYTHON='/Users/hne/.pyenv/shims/python3'

export EDITOR=nvim
