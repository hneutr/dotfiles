export ZPLUG_HOME=~/.zplug
export ZPLUG_LOADFILE=~/.zsh/zplug.zsh

if [[ -f $ZPLUG_HOME/init.zsh ]]; then
	source $ZPLUG_HOME/init.zsh

	if ! zplug check --verbose; then
		printf "Install? [y/N]: "

		if read -q; then
			echo; zplug install
		fi
		echo
	fi

	zplug load
fi

# set dircolors
eval `dircolors -b $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`

function get_prompt() {
	local shortpwd="${PWD/$HOME/~}"
	echo "$fg[yellow]$shortpwd $reset_color> "
}

# enable reactive prompt substitution
setopt PROMPT_SUBST
PROMPT='$(get_prompt)'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
