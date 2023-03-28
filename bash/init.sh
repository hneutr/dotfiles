function init() {
    local _DIR="$(dotpath bash)"
    ln -sf $_DIR $HOME/.bash
    ln -sf $_DIR/bash_profile.sh $HOME/.bash_profile
    ln -sf $_DIR/rc.sh $HOME/.bashrc
}
init
