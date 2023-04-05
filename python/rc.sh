# change prompt for venvs manually, disable their default shit (it's borked up)
export VIRTUAL_ENV_DISABLE_PROMPT=1

#----------------------------------[ pyenv ]-----------------------------------#
if [ -x "$(command -v pyenv)" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    # pyenv-virtualenv is slow, so change it from a precmd to a prepwd
    # (does mean that the prompt isn't # updated)
    eval "$(pyenv virtualenv-init - | sed s/precmd/prepwd/g)"
fi
