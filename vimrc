"==========[ load startup files ]==========
runtime startup/settings.vim
runtime startup/plugins.vim
runtime startup/functions.vim
runtime startup/autocommands.vim
runtime startup/abbreviations.vim
runtime startup/mappings.vim

"==========[ load local settings ]==========
let s:local_vimrc = expand("~/.vimrc_local")
if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
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
	setlocal spell
endfunction

command! -nargs=0 Text call UnstructuredText()

" use tab for indenting/unindenting
vnoremap <tab> >gv|
vnoremap <s-tab> <gv
