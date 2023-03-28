export XDG_CONFIG_HOME=$HOME/.config

[[ "$(uname)" = "Darwin" ]] && source "$(dotpath os/macos/exports.sh)"
