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
export PATH=$PATH:/Users/hne/Library/Python/3.6/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/Library/TeX/texbin
export PATH=$PATH:/Users/hne/.bin

export EDITOR=nvim

# set bindkey delay to 10ms
export KEYTIMEOUT=1

# stupid fzf wouldn't search my documents directory
[[ -z $(which rg) ]] && export FZF_DEFAULT_COMMAND='rg --files'
[[ -z $(which bfs) ]] && export FZF_ALT_C_COMMAND="bfs -type d -nohidden"  

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

# open up a nvim terminal if it's not running
# (would be sick but there's a weird shada error)
# if ! [[ -v NVIM_LISTEN_ADDRESS ]]; then
# 	nvim +term
# fi

# testing
# set it up so that neovim changes local working directory on cd
# neovim_autocd() {
#     [[ $NVIM_LISTEN_ADDRESS ]] && neovim-autocd.py
# }

# chpwd_functions+=( neovim_autocd )
