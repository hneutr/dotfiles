################################################################################
# Options
################################################################################

# show completions automatically
setopt AUTO_LIST

# remove extraneous blanks from history
setopt HIST_REDUCE_BLANKS

# add to history before shell exit
setopt INC_APPEND_HISTORY

# beep sucks
setopt NO_BEEP

# no beep for autocomplete
setopt NO_LIST_BEEP

# interactive prompt (changes on cd/etc)
setopt PROMPT_SUBST

# share history across shells
setopt SHARE_HISTORY

################################################################################
# Exports
################################################################################

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/Users/hne/Library/Python/3.6/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/Library/TeX/texbin

export EDITOR=nvim

# set bindkey delay to 10ms
export KEYTIMEOUT=1

# stupid fzf wouldn't search my documents directory
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_ALT_C_COMMAND="bfs -type d -nohidden"  

################################################################################
# Plugin Setup
################################################################################

# load plugins
[ -f ~/.zsh/zplug.zsh ]    && source ~/.zsh/zplug.zsh

# set up fzf
[ -f ~/.fzf.zsh ]          && source ~/.fzf.zsh

################################################################################
# General
################################################################################

# colors
[ -f ~/.zsh/colors.zsh ]   && source ~/.zsh/colors.zsh

# aliases
[ -f ~/.zsh/aliases.zsh ]  && source ~/.zsh/aliases.zsh

# prompt
[ -f ~/.zsh/prompt.zsh ]   && source ~/.zsh/prompt.zsh

# bindings
[ -f ~/.zsh/bindings.zsh ] && source ~/.zsh/bindings.zsh

# commands/lib
[ -f ~/.zsh/lib.zsh ]      && source ~/.zsh/lib.zsh

# local settings
[ -f ~/.zshrc_local ]      && source ~/.zshrc_local

# open up a nvim terminal if it's not running
# (would be sick but there's a weird shada error)
# if ! [[ -v NVIM_LISTEN_ADDRESS ]]; then
# 	nvim +term
# fi
