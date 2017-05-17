"==========[ load startup files ]==========
runtime startup/settings.vim
runtime startup/mappings.vim
runtime startup/plugins.vim
runtime startup/functions.vim
runtime startup/autocommands.vim
runtime startup/abbreviations.vim

" add plugins to rtp so that ultisnips picks them up
set runtimepath+=~/.vim/startup/plugins/

"==========[ load local settings ]==========
let s:local_vimrc = expand("~/.vimrc_local")
if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
endif

set background=dark
colorscheme solarized

" SignColumn should be same color as line number column
highlight clear SignColumn

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

" this is currently taken by app shortcuts at the alfred-level
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

" digraphs
" inoremap <expr> <c-k> ShowDigraphs()

" function! ShowDigraphs()
" 	digraphs
" 	call getchar()
" 	return "\<c-k>"
" endfunction

" open last window in split/vsplit
nnoremap <c-s-l> :vsb#<cr>
nnoremap <c-s-l> :sb#<cr>
