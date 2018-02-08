export ZPLUG_HOME=/usr/local/opt/zplug
export ZPLUG_LOADFILE=~/.zsh/zplugins.zsh

if [[ -f $ZPLUG_HOME/init.zsh ]]; then
    source $ZPLUG_HOME/init.zsh

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "

        if read -q; then
            echo; zplug install
        fi
        echo
    fi

    zplug load
fi
