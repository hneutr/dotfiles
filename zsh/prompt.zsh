function set_prompt() {
	echo "%{$fg[yellow]%}${PWD/$HOME/~} %{$reset_color%}> "
}

# enable reactive prompt substitution
setopt PROMPT_SUBST
PROMPT='$(set_prompt)'
