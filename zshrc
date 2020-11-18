[ -f ~/.zsh/settings.zsh ] && source ~/.zsh/settings.zsh

################################################################################
# Exports
################################################################################
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/bin/python:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$PATH:$HOME/.cargo/bin

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

################################################################################
# Zinit
################################################################################
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

################################################################################
# Plugin Setup
################################################################################

# load plugins
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

zinit light zsh-users/zsh-completions
zinit light zdharma/fast-syntax-highlighting
zinit load zdharma/history-search-multi-word

zinit light seebi/dircolors-solarized
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git

# set up fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

################################################################################
# General
################################################################################

# colors
[ -f ~/.zsh/colors.zsh ] && source ~/.zsh/colors.zsh

# aliases
[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh

# prompt
[ -f ~/.zsh/prompt.zsh ] && source ~/.zsh/prompt.zsh

# bindings
[ -f ~/.zsh/bindings.zsh ] && source ~/.zsh/bindings.zsh

# commands/lib
[ -f ~/.zsh/lib.zsh ] && source ~/.zsh/lib.zsh

# local settings
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
