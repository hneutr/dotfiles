################################################################################
# Exports
################################################################################
export PATH="$(pyenv root)/shims:$PATH"
export PATH="${HOME}/.bin:$PATH"

# I hate everything
export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include -I/usr/local/opt/bzip2/include"
# I hate everything

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/usr/local/lib/fst

export XDG_CONFIG_HOME=$HOME/.config
export MPLCONFIGDIR=$XDG_CONFIG_HOME/matplotlib

export EDITOR=nvim

# set bindkey delay to 10ms
export KEYTIMEOUT=1

# make a history file if there isn't one
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

# stupid fzf wouldn't search my documents directory
[[ ! -z $(which rg) ]] && export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/*'"
[[ ! -z $(which bfs) ]] && export FZF_ALT_C_COMMAND="bfs -type d -nohidden 2>/dev/null"  # maybe -hidden?

# change prompt for venvs manually, disable their own borked up shit
export VIRTUAL_ENV_DISABLE_PROMPT=1

source ~/dotfiles/shell/prompt.sh
source ~/dotfiles/shell/aliases.sh

# year month
export YM="$(date +20%y%m)"

# today
export TD="$(date +20%y%m%d)"

# make sed better on OSX
export LC_CTYPE=C 
export LANG=C
