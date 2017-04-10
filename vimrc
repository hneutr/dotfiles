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

" this stuff is from justinmk
let g:surround_indent = 1

" mark before searching... stupid simple
nnoremap / ms/

inoremap <M-o> <C-O>o
inoremap <M-O> <C-O>O

" use grepprg instead of ack.vim
if executable('ag')
	set grepprg=ag\ --vimgrep
endif
nnoremap <silent> K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" more instantly better vim
" highlight things past 80 columns
" highlight ColorColumn ctermbg=0
" call matchadd('ColorColumn', '\%81v', 100)

" digraphs
" inoremap <expr> <c-k> ShowDigraphs()

" function! ShowDigraphs()
" 	digraphs
" 	call getchar()
" 	return "\<c-k>"
" endfunction

highligh clear SignColumn

