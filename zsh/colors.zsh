if [[ "$(uname)" = "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
else
    if [[ -f $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark ]]; then
	eval `dircolors -b $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
    fi
fi
