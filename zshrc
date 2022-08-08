[ -f ~/.zsh/settings.zsh ] && source ~/.zsh/settings.zsh

# this is path/etc
source ~/dotfiles/shell/exports.sh

################################################################################
# Plugin Setup
################################################################################
source $HOME/dotfiles/zsh/plugins/F-Sy-H/F-Sy-H.plugin.zsh

################################################################################
# General
################################################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zsh/colors.zsh
source ~/.zsh/bindings.zsh

# commands/lib
source ~/.zsh/lib.zsh

# call the change directory functions when starting
# change_directory_functions
chpwd

################################################################################
# Prompt
################################################################################
function set_prompt() {
    echo "$(venv_prompt_string)%{$fg[yellow]%}${PWD/$HOME/~} %{$reset_color%}> "
}

export PROMPT='$(set_prompt)'
