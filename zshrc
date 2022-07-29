[ -f ~/.zsh/settings.zsh ] && source ~/.zsh/settings.zsh

# this is path/etc
source ~/dotfiles/shell/exports.sh

################################################################################
# Plugin Setup
################################################################################
source $HOME/dotfiles/zsh/plugins/F-Sy-H/F-Sy-H.plugin.zsh

# if type brew &>/dev/null; then
#     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

#     autoload -Uz compinit
#     compinit
# fi

################################################################################
# General
################################################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zsh/colors.zsh
source ~/.zsh/bindings.zsh

# commands/lib
source ~/.zsh/lib.zsh

################################################################################
# Prompt
################################################################################
function set_prompt() {
    echo "$(venv_prompt_string)%{$fg[yellow]%}${PWD/$HOME/~} %{$reset_color%}> "
}

export PROMPT='$(set_prompt)'
