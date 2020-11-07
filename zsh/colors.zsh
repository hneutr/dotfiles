if [[ "$(uname)" = "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
else
    if [[ -f $HOME/.zinit/plugins/seebi---dircolors-solarized/dircolors.256dark ]]; then
			eval `dircolors -b $HOME/.zinit/plugins/seebi---dircolors-solarized/dircolors.256dark`
    fi
fi
