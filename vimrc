"==========[ load startup files ]==========
runtime startup/settings.vim
runtime startup/plugins.vim
runtime startup/functions.vim
runtime startup/autocommands.vim
runtime startup/abbreviations.vim
runtime startup/mappings.vim

"==========[ load local settings ]==========
let $LOCALFILE = expand("~/.vimrc_local")
if filereadable($LOCALFILE)
	source $LOCALFILE
endif

set background=dark
colorscheme solarized

"==========[ testing ]==========

