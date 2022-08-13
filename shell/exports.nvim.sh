export NVIM_PATH=/usr/local/bin/nvim

export NVIM_APP_PATH=$DOTDIR/nvim/app/squashfs-root/usr/bin/nvim
[[ -f "$NVIM_APP_PATH" ]] && export NVIM_PATH=$NVIM_APP_PATH

export NVIM_PYTHON=$HOME/.pyenv/shims/python3

export EDITOR=nvim
