if [[ "$(uname)" = "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
else
	eval `dircolors -b $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
fi
