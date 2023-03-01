# change prompt for venvs manually, disable their default shit (it's borked up)
export VIRTUAL_ENV_DISABLE_PROMPT=1

export MPLCONFIGDIR=$XDG_CONFIG_HOME/matplotlib

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null || eval "$(pyenv init -)"
command -v pyenv >/dev/null || eval "$(pyenv virtualenv-init -)"
