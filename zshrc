export PATH=$PATH:/usr/local/bin

export editor=nvim

################################################################################
# Plugin Setup
################################################################################

# load plugins
[ -f ~/.zsh/zplug.zsh ] && source ~/.zsh/zplug.zsh

# set up fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# stupid fzf wouldn't search my documents directory
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_ALT_C_COMMAND="bfs -type d -nohidden"  

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
