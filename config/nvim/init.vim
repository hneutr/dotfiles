"===============================================================================
"======================[ structure and guiding principles ]=====================
"===============================================================================
" 1. Be consistent. 
" 2. Readability is valuable.
" 3. Functional value > Aesthetic value
" 4. Comment regularly
" 5. Comment only when useful
" 5. Build for yourself.

" Style:
" - comments on the line above their referant

"==================================[ settings ]=================================
" write whenever you can
set autowriteall

set background=dark

" excluded completion types:
"             |---> don't scan included files
"             ||--> don't scan tags
set complete-=it

set dictionary="/usr/dict/words"

set fileformats=unix,dos,mac

" use ag if it is available
if executable('ag')
	set grepprg=ag\ --vimgrep
endif

" cursor magic:
"	insert = block
"	i = line
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,
	\i-ci:ver25-Cursor/lCursor,
	\r-cr:hor20-Cursor/lCursor

" show results of a command while typing
set inccommand=nosplit

" redraw less often
set lazyredraw

set nocursorline

set noerrorbells

" don't make .swp files
set noswapfile

set novisualbell

set nowrap

set number

set scrolloff=10

set sidescroll=1

set sidescrolloff=5

" messages:
" ----> shorten status updates
set shortmess=a
" ----> don't show completion messages
set shortmess+=c

" show commands
set showcmd

" highlight matchpairs
set showmatch

set splitbelow

set splitright

" statusline:
" ----> full path (100 characters)
set statusline=%.100F
" ----> right side
set statusline+=%=
" ----> column
set statusline+=%c

" make ~ an operator
set tildeop	

" extend mapping timeout time
set timeoutlen=1000

" shorten key code timeout time
set ttimeoutlen=0

set undodir=~/.config/nvim/undodir

set undofile

" ignore file types in completion
set wildignore+=.DS_Store,.git,*.tmp,*.swp,*.png,*.jpg,*.gif

set wildignorecase

set wildmode=list:longest,full

"===================================[ folds ]===================================
set nofoldenable

set foldmethod=indent
" only fold 1 level
set foldnestmax=1
" custom fold function
set foldtext=lib#FoldDisplayText()

"================================[ indentation ]================================
set smartindent

set smarttab

set shiftwidth=4

set softtabstop=4

set tabstop=4

" if there are spaces when </>, round down
set shiftround

"=================================[ searching ]=================================
" ignore case when searching
set ignorecase 

" make completions case-intelligent
set infercase

" override ignore case if search includes capital letters
set smartcase

"=================================[ formatting ]================================
" ftplugins play with this stuff so settings have to be put in after/
" (see /after/plugin/formatting.vim)

"================================[ config vars ]================================
let g:vim_config = $HOME . "/.config/nvim"
let g:plugged_path = g:vim_config . "/plugged"

let mapleader = "\<space>"
let maplocalleader = "\<space>"

"===============================================================================
"==================================[ plugins ]==================================
"===============================================================================
call plug#begin(g:plugged_path)

"=================================[ interface ]=================================
Plug 'altercation/vim-colors-solarized'                            " colorscheme
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do': './install --all' } " install fzf
Plug 'junegunn/fzf.vim'                                            " fzf for vim
Plug 'mbbill/undotree'                                             " undo tree
Plug 'tpope/vim-unimpaired'                                        " paired options
Plug 'w0rp/ale'                                                    " asynchronous lint engine

"================================[ text editing ]===============================
Plug 'AndrewRadev/splitjoin.vim'       " join/split lines
Plug 'SirVer/ultisnips'                " snippet engine
Plug 'honza/vim-snippets'              " predefined snippets
Plug 'junegunn/vim-easy-align'         " align text at a separator
Plug 'justinmk/vim-sneak'              " 2char motions
Plug 'tpope/vim-commentary'            " comment language-agnostically
Plug 'tpope/vim-speeddating'           " smarter date logic
Plug 'tpope/vim-surround'              " deal with pairs
Plug 'vim-scripts/ReplaceWithRegister' " without overwriting
Plug 'wellle/targets.vim'              " more text objects

"====================================[ tmux ]===================================
Plug 'christoomey/vim-tmux-navigator'     " move seamlessly between tmux/vim splits
Plug 'christoomey/vim-tmux-runner'        " rerun tests
Plug 'roxma/vim-tmux-clipboard'           " paste between vim windows across tmux
Plug 'tmux-plugins/vim-tmux-focus-events' " focus events for tmux+vim
Plug 'wellle/tmux-complete.vim'           " autocomplete across tmux panes

"==============================[ language/syntax ]==============================
Plug 'sheerun/vim-polyglot'                          " many languages
Plug 'Glench/Vim-Jinja2-Syntax', { 'for' : 'jinja' } " jinja...

"==================================[ writing ]==================================
Plug 'junegunn/goyo.vim' " distraction free + centered editing

"==================================[ testing ]==================================
Plug 'wellle/visual-split.vim'                                           " opening specific-sized splits
Plug 'reedes/vim-textobj-sentence'                                       " improved sentence object
Plug 'shougo/denite.nvim'                                                " meta-whackness 10
Plug 'autozimu/LanguageClient-neovim', { 'do' : ':UpdateRemotePlugins' } " LSP

call plug#end()

"==============================[ plugin settings ]==============================
" fzf
let g:fzf_action = { 'ctrl-l': 'vsplit', 'ctrl-j': 'split' }

" surround
let g:surround_indent = 1

runtime startup/plugins/denite.vim
runtime startup/plugins/schlepp.vim
runtime startup/plugins/sneak.vim
runtime startup/plugins/ultisnips.vim

"===============================================================================
"==================================[ mappings ]=================================
"===============================================================================

"================================[ normal mode ]================================
" select what was just pasted 
nnoremap gV `[v`]

" alias of "verticalsplit" (for consistency with tmux)
nnoremap <c-w>1 <c-w>H

" alias of "split" (for consistency with tmux)
nnoremap <c-w>2 <c-w>K

" swap */# (match _W_ord) and g*/g# (match _w_ord)
nnoremap * g*
nnoremap g* *
nnoremap # g#
nnoremap g# #

" play last macro
nnoremap Q @@

" yank to end of line (match C/D)
nnoremap Y y$

" change case of character under cursor
nnoremap ~~ ~l

" stop highlighting searched terms
nnoremap <silent> <leader><space> :nohlsearch<cr>

" edit vimrc
nnoremap <leader>vv :sp $MYVIMRC<cr>

" source vimrc
nnoremap <leader>vs :source $MYVIMRC<cr>:nohlsearch<cr>

" don't store "{"/"}" motions in jump list
nnoremap <silent> } :<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>
nnoremap <silent> { :<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>

" mark before searching
nnoremap / ms/
nnoremap ? ms?

" move to end/start of line more easily
nnoremap <space>l $
nnoremap <space>h ^

" Conditionally modify character at end of line
nnoremap <silent> <leader>, :call lib#ModifyLineEndDelimiter(',')<cr>
nnoremap <silent> <leader>; :call lib#ModifyLineEndDelimiter(';')<cr>

" search files more easily
nnoremap \ :Ag<SPACE>

" grep for current word
nnoremap <silent> K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" 'do' mappings
nnoremap <leader>df :FZF<cr>
nnoremap <leader>dg :Goyo<cr>
nnoremap <leader>dw :call lib#UnstructuredText()<cr>
nnoremap <silent> <leader>du :UltiSnipsEdit<cr>
nnoremap <leader>dt :UndotreeToggle<cr>

"================================[ insert mode ]================================

" save the pinky
inoremap jk <esc>
inoremap kj <esc>
inoremap <c-c> <nop>

" forward delete (consistent with osx)
inoremap <c-d> <del>

" untab/retab (default mapping used above)
inoremap <c-l> <c-t>
inoremap <c-h> <c-d>

" close various structures automatically
" newline triggered
inoremap (<cr> (<cr>)<esc>O
inoremap [<cr> [<cr>]<esc>O
inoremap {<cr> {<cr>}<esc>O
inoremap <<cr> <<cr>><esc>O
inoremap """<cr> """<cr>"""<esc>O

" semicolon triggered
inoremap (; ();<esc>hi
inoremap [; [];<esc>hi
inoremap {; {};<esc>hi

" comma triggered
inoremap (, (),<esc>hi
inoremap {, {},<esc>hi
inoremap [, [],<esc>hi
inoremap ', '',<esc>hi
inoremap ", "",<esc>hi
inoremap `, ``,<esc>hi

" tab triggered
inoremap (<tab> ()<esc>i
inoremap [<tab> []<esc>i
inoremap {<tab> {}<esc>i
inoremap <<tab> <><esc>i
inoremap '<tab> ''<esc>i
inoremap "<tab> ""<esc>i
inoremap `<tab> ``<esc>i
inoremap _<tab> __<esc>i
inoremap __<tab> ____<esc>hi
inoremap *<tab> **<esc>i
inoremap **<tab> ****<esc>hi

"================================[ visual mode ]================================
" unindent/indent
vnoremap > >gv
vnoremap < <gv

" paste without overwriting buffer
vnoremap r "_dP"

"==========================[ normal and visual modes ]==========================
" bind easy align keys
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" move vertically by visual line
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

" recenter the screen after jumping forward
nnoremap <c-f> <c-f>zz
vnoremap <c-f> <c-f>zz

" recenter the screen after jumping backward
nnoremap <c-b> <c-b>zz
vnoremap <c-b> <c-b>zz

" make n always go forward; recenter after jumping
nnoremap <expr> n 'Nn'[v:searchforward].'zz'
vnoremap <expr> n 'Nn'[v:searchforward].'zz'

" make N always go back; recenter after jumping
nnoremap <expr> N 'nN'[v:searchforward].'zz'
vnoremap <expr> N 'nN'[v:searchforward].'zz'

" Move current line / visual line selection up or down.
nnoremap <M-j> :m+<CR>==
nnoremap <M-k> :m-2<CR>==
vnoremap <M-j> :m'>+<CR>gv=gv
vnoremap <M-k> :m-2<CR>gv=gv

"================================[ command mode ]===============================
" make start of line and end of line movements match zsh/bash
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Move by word
cnoremap <m-b> <s-left>
cnoremap <m-f> <s-right>

" make commandline history smarter (use text entered so far)
cnoremap <c-n> <up>
cnoremap <c-p> <down>

"===============================================================================
"================================[ autocommands ]===============================
"===============================================================================
if empty(g:plugged_path)
	autocmd! VimEnter * PlugInstall
endif

augroup startup
	autocmd!

	autocmd BufEnter,FocusGained * :call lib#NumberToggle(1)
	autocmd BufLeave,FocusLost * :call lib#NumberToggle(0)

augroup END

" Save all the time
augroup save
	autocmd!

	" write events
	autocmd BufLeave,FocusLost,InsertLeave,TextChanged * silent! wall
	
	" read events
	autocmd BufEnter,BufWinEnter,CursorHold,FocusGained * silent! checktime
augroup END

"===============================================================================
"===============================[ abbreviations ]===============================
"===============================================================================

"===============================================================================
"==================================[ commands ]=================================
"===============================================================================

command! -nargs=0 Text call lib#UnstructuredText()

command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

command! -nargs=1 H call lib#ShowHelp(<f-args>)

"===============================================================================
"===================================[ colors ]==================================
"===============================================================================

colorscheme solarized

" SignColumn should be same color as line number column
highlight clear SignColumn

highlight statusline ctermfg=0

highlight statusline ctermbg=14

highlight Folded cterm=NONE

"===============================================================================
"===============================[ miscellaneous ]===============================
"===============================================================================

"====================[ load local vimrc ]====================
let s:local_vimrc = expand("~/.vimrc_local")
if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
endif

"===============================================================================
"==================================[ testing ]==================================
"===============================================================================

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  setlocal noshowmode
  setlocal noshowcmd
  setlocal scrolloff=999
  setlocal sidescroll=0
  setlocal spell
  set wrap
  set linebreak
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  setlocal showmode
  setlocal showcmd
  setlocal scrolloff=10
  setlocal nospell
  set nowrap
  set nolinebreak
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" LSP
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {}

let g:LanguageClient_diagnosticsDisplay = {
	\ 1: { 
		\"name": "Error",
		\"texthl": "ALEError", 
		\"signText": "➤",
		\"signTexthl": "ALEErrorSign",
		\},
	\2: {
		\"name": "Warning",
		\"texthl": "ALEWarning",
		\"signText": "➤",
		\"signTexthl": "ALEWarningSign",
		\},
	\3: {
		\"name": "Information",
		\"texthl": "ALEInfo",
		\"signText": "➤",
		\"signTexthl": "ALEInfoSign",
		\},
	\4: {
		\"name": "Hint",
		\"texthl": "ALEInfo",
		\"signText": "➤",
		\"signTexthl": "ALEInfoSign",
		\},
	\}

" \"signText": "✖", 
" \"signText": "⚠",
" \"signText": "ℹ",

" let g:LanguageClient_notify

if executable('javascript-typescript-stdio')
	let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
endif

if executable('pyls')
	let g:LanguageClient_serverCommands.python = ['pyls']
endif

augroup LanguageClientConfig
	autocmd!

	" <leader>ld to go to definition
	autocmd FileType javascript,python nnoremap <buffer> <leader>ld :call LanguageClient_textDocument_definition()<cr>
	" <leader>lf to autoformat document
	autocmd FileType javascript,python nnoremap <buffer> <leader>lf :call LanguageClient_textDocument_formatting()<cr>
	" <leader>lh for type info under cursor
	autocmd FileType javascript,python nnoremap <buffer> <leader>lh :call LanguageClient_textDocument_hover()<cr>
	" <leader>lr to rename variable under cursor
	autocmd FileType javascript,python nnoremap <buffer> <leader>lr :call LanguageClient_textDocument_rename()<cr>
	" <leader>lc to switch omnifunc to LanguageClient
	autocmd FileType javascript,python nnoremap <buffer> <leader>lc :setlocal omnifunc=LanguageClient#complete<cr>
	" <leader>ls to fuzzy find the symbols in the current document
	autocmd FileType javascript,python nnoremap <buffer> <leader>ls :call LanguageClient_textDocument_documentSymbol()<cr>
	" Use LanguageServer for omnifunc completion
	autocmd FileType javascript,python setlocal omnifunc=LanguageClient#complete
augroup END

" autoformat paragraphs (see autoformat)
" set formatoptions+=a

" use the second line of the paragraph instead of the first for indent (should
" prolly be in an augroup for markdown)
" set formatoptions+=2

" lookup whichwrap
" make h/l move across beginning/end of line
" set whichwrap+=hl
" use enter as colon for faster commands (smart)
nnoremap <cr> :
vnoremap <cr> :
" meta enter in case you need a real <cr>
nnoremap <M-cr> <cr>
vnoremap <M-cr> <cr>

" Close quickfix & help with q, Escape, or Control-C
" Also, keep default <cr> binding
augroup easy_close
	autocmd!
	autocmd FileType help,qf nnoremap <buffer> q :q<cr>
	autocmd FileType help,qf nnoremap <buffer> <Esc> :q<cr>
	autocmd FileType help,qf nnoremap <buffer> <C-c> :q<cr>
	" Undo <cr> -> : shortcut
	autocmd FileType help,qf nnoremap <buffer> <cr> <cr>
augroup END

" save more easily
" nnoremap <leader>w :w<cr>
nnoremap <leader>w :echoerr "stop it you have autosave"<cr>
cabbrev w echoerr "stop it you have autosave"
