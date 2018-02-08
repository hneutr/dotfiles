# interactive prompt (changes on cd/etc)
setopt prompt_subst

function set_prompt() {
	echo "%{$fg[yellow]%}${PWD/$HOME/~} %{$reset_color%}> "
}

PROMPT='$(set_prompt)'
