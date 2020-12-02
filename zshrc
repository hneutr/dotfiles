[ -f ~/.zsh/settings.zsh ] && source ~/.zsh/settings.zsh

# this is path/etc
source ~/dotfiles/shell/exports.sh

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
