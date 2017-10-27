# Add homebrew's path
export PATH=$PATH:/usr/local/bin

export editor=nvim

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

if [[ "$(uname)" = "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
else
	eval `dircolors -b $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
fi

function set_prompt() {
	echo "%{$fg[yellow]%}${PWD/$HOME/~} %{$reset_color%}> "
}

# enable reactive prompt substitution
setopt PROMPT_SUBST
PROMPT='$(set_prompt)'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh
[ -f ~/.zshrc_local ] && source ~/.zshrc_local

export ROAMER_DATA_PATH=~/.config

# convert a markdown file into a pdf, swapping only the extension
topdf () {
	local output="${1:r}.pdf"
	markdown-pdf $1 -o $output 2> /dev/null
}

# stupid fzf wouldn't search my documents directory
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_ALT_C_COMMAND="bfs -type d -nohidden"  
