function set_prompt() {
    echo "$(venv_prompt_string)%{$fg[yellow]%}${PWD/$HOME/~} %{$reset_color%}> "
}

export PROMPT='$(set_prompt)'
