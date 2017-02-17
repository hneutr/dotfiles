"==============================================================================
" Plugins
"==============================================================================
if empty('~/.vim/plugged')
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

if ! has('nvim')
	Plug 'noahfrederick/vim-neovim-defaults'
endif

"==========[ interface ]==========
Plug 'altercation/vim-colors-solarized'                            " colorscheme
Plug 'hunter-/tester.vim'                                          " pair test files
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do': './install --all' } " install fzf
Plug 'junegunn/fzf.vim'                                            " fzf for vim
Plug 'mileszs/ack.vim'                                             " better vimgrep
Plug 'neomake/neomake'                                             " async linting
Plug 'tpope/vim-unimpaired'                                        " paired options

"==========[ text editing ]==========
Plug 'AndrewRadev/splitjoin.vim' " join/split lines
Plug 'junegunn/vim-easy-align'   " align text at a separator
Plug 'tpope/vim-commentary'      " comment language-agnostically
Plug 'tpope/vim-speeddating'     " smarter date logic
Plug 'tpope/vim-surround'        " deal with pairs
Plug 'wellle/targets.vim'        " better text objects

"==========[ tmux ]==========
Plug 'christoomey/vim-tmux-navigator'     " move seamlessly between tmux/vim splits
Plug 'roxma/vim-tmux-clipboard'           " paste between vim windows in different tmux spots
Plug 'tmux-plugins/vim-tmux-focus-events' " focus events for tmux+vim
Plug 'wellle/tmux-complete.vim'           " autocomplete across tmux panes

"==========[ language ]==========
Plug 'Yggdroot/indentLine', { 'for' : 'python' }                " show indent lines in python
Plug 'mustache/vim-mustache-handlebars', { 'for' : 'mustache' } " syntax for mustache
Plug 'tmux-plugins/vim-tmux'                                    " syntax for .tmux.conf files
Plug 'vim-perl/vim-perl', { 'for' : 'perl' }                    " syntax for perl

"==========[ writing ]==========
Plug 'junegunn/goyo.vim' " distraction free + centered editing
Plug 'reedes/vim-pencil' " autowrap lines

"==========[ testing ]==========
Plug 'wellle/visual-split.vim' " opening specific-sized splits
" Plug 'justinmk/vim-sneak'    " looks awesome but I love 's' and :( surround.vim
" Plug 'tpope/vim-endwise'     " end some structures automatically (but
                               " conflicts with pencil)

call plug#end()

"==============================================================================
" General
"==============================================================================

"==========[ general ]==========
let mapleader="\<space>"

set background=dark
colorscheme solarized

set dictionary="/usr/dict/words"
set foldenable
set lazyredraw
set tildeop	" tilde should be an operator

"==========[ interface ]==========
set noerrorbells
set novisualbell
set number
set nocursorline
set nowrap
set smartindent
set showcmd
set shortmess=ac
set showmatch     " highlight matching braces
set timeoutlen=1000
set ttimeoutlen=0 " no pause on esc

"==========[ files ]==========
set autowriteall
set fileformats=unix,dos,mac
set noswapfile
set undofile
set undodir=~/.vim/undodir

"==========[ tabs ]==========
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround

"==========[ completion ]==========
set wildmode=list:longest,full
set wildignorecase
set wildignore+=.DS_Store,.git
set wildignore+=*.tmp,*.swp
set wildignore+=*.png,*.jpg,*.gif
set complete-=i " don't scan included files
set complete-=t " don't scan tags
if has('nvim')
	set inccommand=nosplit
endif

"==========[ searching ]==========
set ignorecase " ignore case
set smartcase  " case insensitive search becomes sensitive with capitals
set infercase  " allow completions to be case-smart

"==========[ scrolling ]==========
set scrolloff=10
set sidescroll=1
set sidescrolloff=5

"==========[ splits ]==========
set splitbelow
set splitright

"==========[ statusline ]==========
hi statusline ctermfg=0
hi statusline ctermbg=14
set statusline=%.100F " Full path (100 chars)
set statusline+=%=    " right side
set statusline+=%c    " column

"==============================================================================
" Mappings
"==============================================================================

"==========[ normal ]==========
" select what was just pasted 
nnoremap gV `[v`]

" side-by-side windows
nnoremap <c-w>1 <c-w>H
" stacked windows
nnoremap <c-w>2 <c-w>K

" */# to not map whole word; map g*/g# to match whole word
nnoremap * g*
nnoremap g* *
nnoremap # g#
nnoremap g# #

" turn off highlighting
nnoremap <silent> <leader><space> :nohlsearch<cr>

" Conditionally modify character at end of line
nnoremap <silent> <leader>, :call ModifyLineEndDelimiter(',')<cr>
nnoremap <silent> <leader>; :call ModifyLineEndDelimiter(';')<cr>

" remove trailing whitespace
nnoremap <leader>w :%s/\s\+$//<cr>nohlsearch<cr>

" edit and load vimrc
nnoremap <leader>vv :sp $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>:nohlsearch<cr>

" I don't use ex mode; play last macro
nnoremap Q @@

" don't store "{"/"}" motions in jump list
nnoremap <silent> } :<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>
nnoremap <silent> { :<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>

" yank to end of line; consistency is king
nnoremap Y y$

" change case of character under cursor
nnoremap ~~ ~l

"==========[ insert ]==========

" don't cancel iabbrevs on exit
imap <c-c> <esc>

" forward delete
inoremap <c-d> <del>

" close various structures automatically
inoremap (<cr> (<cr>)<esc>O
inoremap (<tab> ()<esc>i

inoremap [<cr> [<cr>]<esc>O
inoremap [<tab> []<esc>i

inoremap {<cr> {<cr>}<esc>O
inoremap {<tab> {}<esc>i

inoremap <<cr> <<cr>><esc>O
inoremap <<tab> <><esc>i

inoremap '<tab> ''<esc>i

inoremap "<tab> ""<esc>i

inoremap `<tab> ``<esc>i

" more intuitive completion mappings
inoremap <c-j> <c-n>
inoremap <c-k> <c-p>
inoremap <c-u> <c-x><c-u>
inoremap <c-f> <c-x><c-f>
inoremap <c-]> <c-x><c-]>
inoremap <c-l> <c-x><c-l>

"==========[ visual ]==========
" unindent/indent
vnoremap > >gv
vnoremap < <gv

" paste without overwriting buffer
vnoremap r "_dP"

" search by visual selection
vnoremap <silent> * :<c-u>call VisualSelection('', '')<cr>/<c-r>=@/<cr><cr>
vnoremap <silent> # :<c-u>call VisualSelection('', '')<cr>?<c-r>=@/<cr><cr>

"==========[ normal/visual ]==========

" move vertically by visual line
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

" when jumping, recenter
nnoremap <c-f> <c-f>zz
vnoremap <c-f> <c-f>zz

nnoremap <c-b> <c-b>zz
vnoremap <c-b> <c-b>zz

" make n always go forward and N always go back 
nnoremap <expr> n 'Nn'[v:searchforward].'zz'
vnoremap <expr> n 'Nn'[v:searchforward].'zz'
nnoremap <expr> N 'nN'[v:searchforward].'zz'
vnoremap <expr> N 'nN'[v:searchforward].'zz'

"==========[ normal/visual/insert ]==========
inoremap <up> <nop>
nnoremap <up> <nop>
vnoremap <up> <nop>

inoremap <down> <nop>
nnoremap <down> <nop>
vnoremap <down> <nop>

inoremap <left> <nop>
nnoremap <left> <nop>
vnoremap <left> <nop>

inoremap <right> <nop>
nnoremap <right> <nop>
vnoremap <right> <nop>

"==========[ command ]==========
" Bash-like hotkeys for navigation
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Move back
cnoremap <c-b> <left>

" Move by word
cnoremap <m-b> <s-left>
cnoremap <m-f> <s-right>

" make commandline history smarter (use text entered so far)
cnoremap <c-n> <up>
cnoremap <c-p> <down>

"==============================================================================
" Abbrievations
"==============================================================================
"==========[ date/time ]==========
iabbrev _sdate <c-r>=strftime("%Y/%m/%d")<cr>
iabbrev _date <c-r>=strftime("%m/%d/%y")<cr>

"==============================================================================
" Functions
"==============================================================================

"==========[ ModifyLineEndDelimiter ]==========
" Description:
"	This function takes a delimiter character and:
"	- removes that character from the end of the line if the character at the end
"	of the line is that character
"	- removes the character at the end of the line if that character is a
"	delimiter that is not the input character and appends that character to
"	the end of the line
"	- adds that character to the end of the line if the line does not end with
"	a delimiter
"
" Delimiters:
" - ","
" - ";"
"==========================================
function! ModifyLineEndDelimiter(character)
	let line_modified = 0
	let line = getline('.')

	for character in [',', ';']
		" check if the line ends in a trailing character
		if line =~ character . '$'
			let line_modified = 1

			" delete the character that matches:

			" reverse the line so that the last instance of the character on the
			" line is the first instance
			let newline = join(reverse(split(line, '.\zs')), '')

			" delete the instance of the character
			let newline = substitute(newline, character, '', '')

			" reverse the string again
			let newline = join(reverse(split(newline, '.\zs')), '')

			" if the line ends in a trailing character and that is the
			" character we are operating on, delete it.
			if character != a:character
				let newline .= a:character
			endif

			break
		endif
	endfor

	" if the line was not modified, append the character
	if line_modified == 0
		let newline = line . a:character
	endif

	call setline('.', newline)
endfunction

function! VisualSelection(direction, extra_filter) range
	let l:saved_reg=@"
	execute "normal! vgvy"

	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")

	let l:command = ''
	if a:direction == 'gv'
		let l:command = "Ag \"" . l:pattern . "\" "
	elseif a:direction == 'replace'
		let l:command = "%s" . '/' . l:pattern . '/'
	endif

	exe "menu Foo.Bar :" . l:command
	emenu Foo.Bar
	unmenu Foo

	let @/ = l:pattern
	let @" = l:saved_reg
endfunction

function! StripTrailingWhitespace()
	normal mZ
	%s/\s\+$//e
	normal `Z
	normal mZ
endfunction

" relative is a boolean indicating either
" --> relativenumber (when true)
" --> norelativenumber (when false)
function! NumberToggle(relative)
	if (&number)
		if (a:relative == 1)
			set relativenumber
		else
			set norelativenumber
		endif
	endif
endfunction

"==============================================================================
" Plugins and Misc
"==============================================================================
"==========[ local vimrc ]==========
let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
	source $LOCALFILE
endif

"==========[ tester.vim ]==========
nnoremap <leader>t :call g:tester.OpenPairedFile()<cr>
nnoremap <leader>T :call g:tester.OpenPairedFile('vs')<cr>

"==========[ neomake ]==========
let g:neomake_javascript_jshint_maker = {
	\ 'args': ['--verbose'],
	\ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
	\ }
let g:neomake_javascript_enabled_markers = ['jshint']
let g:neomake_open_list = 2

nnoremap <leader>n :Neomake<cr>

"==========[ Splitjoin ]==========
nnoremap <leader>k :SplitjoinJoin<cr>
nnoremap <leader>j :SplitjoinSplit<cr>

"==========[ ack ]==========
cnoreabbrev ag Ack!
nnoremap <leader>a :Ack!<space>

if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

"==========[ fzf ]==========
nnoremap <leader>f :FZF<cr>

let g:fzf_action = {
	\'ctrl-b': 'vsplit',
	\'ctrl-v': 'split'}

"==========[ easy align ]==========
nmap <Bar> <Plug>(EasyAlign)
xmap <Bar> <Plug>(EasyAlign)

"==============================================================================
" Testing
"==============================================================================

" quickly edit macros
nnoremap <leader>m :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

augroup interface
	autocmd!

	autocmd! BufEnter,FocusGained * :call NumberToggle(1)
	autocmd! BufLeave,FocusLost * :call NumberToggle(0)
augroup END

