function init() {
    local _DIR="$(dotpath zsh)"
    ln -sf $_DIR $HOME/.zsh
    ln -sf $_DIR/zshrc $HOME/.zshrc
    ln -sf $_DIR/zshenv $HOME/.zshenv
}
init
