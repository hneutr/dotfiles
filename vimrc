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
" runtime starup/commands.vim

" sets some stuff up for writing
function! UnstructuredText()
	call pencil#init({ 'wrap' : 'hard' })

	setlocal wrap
	setlocal textwidth=80
endfunction

command -nargs=0 Text call UnstructuredText()
