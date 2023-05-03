[ -z "$NVIM_PATH" ] && export NVIM_PATH=/usr/local/bin/nvim

export NVIM_VERSION="0.8.3"
export NVIM_APP_DIR="$(dotpath nvim/app)"
export NVIM_APP_FILE="$(dotpath nvim/nvim.appimage)"
export NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
export NVIM_PYTHON='/Users/hne/.pyenv/shims/python3'

export EDITOR=nvim
