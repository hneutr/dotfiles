autoload -U colors && colors

if [[ "$(uname)" = "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
fi
