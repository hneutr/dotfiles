source ~/dotfiles/shell/exports.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PS1="\$(venv_prompt_string)\e[33m\w\e[37m > "
