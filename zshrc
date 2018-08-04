################################################################################
# Options
################################################################################

# beep sucks
setopt no_beep

# no beep for autocomplete
setopt no_list_beep

################################################################################
# Exports
################################################################################

export PATH=/usr/local/bin:$PATH
export PATH=$PATH:$HOME/.cargo/bin

export EDITOR=nvim

# set bindkey delay to 10ms
export KEYTIMEOUT=1

# stupid fzf wouldn't search my documents directory
[[ ! -z $(which rg) ]] && export FZF_DEFAULT_COMMAND='rg --files'
[[ ! -z $(which bfs) ]] && export FZF_ALT_C_COMMAND="bfs -type d -nohidden"  

################################################################################
# Plugin Setup
################################################################################

# load plugins
[ -f ~/.zsh/zplug.zsh ] && source ~/.zsh/zplug.zsh

# set up fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

################################################################################
# General
################################################################################

# colors
[ -f ~/.zsh/colors.zsh ] && source ~/.zsh/colors.zsh

# aliases
[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh

# history
[ -f ~/.zsh/history.zsh ] && source ~/.zsh/history.zsh

# prompt
[ -f ~/.zsh/prompt.zsh ] && source ~/.zsh/prompt.zsh

# bindings
[ -f ~/.zsh/bindings.zsh ] && source ~/.zsh/bindings.zsh

# completion
[ -f ~/.zsh/completion.zsh ] && source ~/.zsh/completion.zsh

# commands/lib
[ -f ~/.zsh/lib.zsh ] && source ~/.zsh/lib.zsh

# local settings
[ -f ~/.zshrc_local ] && source ~/.zshrc_local

################################################################################
# Testing
################################################################################
