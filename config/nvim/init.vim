"===============================================================================
"======================[ structure and guiding principles ]=====================
"===============================================================================
" 1. Be consistent. 
" 2. Readability is valuable.
" 3. Functional value > Aesthetic value
" 4. Comment regularly where useful
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

" set foldenable
set nofoldenable

set foldmethod=indent

" only fold 1 level
set foldnestmax=1

" custom fold function
set foldtext=lib#FoldDisplayText()

" use ag if it is available
if executable('ag')
	set grepprg=ag\ --vimgrep
endif

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,
	\i-ci:ver25-Cursor/lCursor,
	\r-cr:hor20-Cursor/lCursor

set inccommand=nosplit

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
"             |---> shorten status updates
"             ||--> don't show completion messages
set shortmess=ac

" show commands
set showcmd

" highlight matchpairs
set showmatch

set splitbelow

set splitright

" statusline:
"              |----------> full path (100 characters)
"              |     |----> right side
"              |     | |--> column
set statusline=%.100F%=%c

" ~ --> operator
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

"================================[ config vars ]================================
let g:vim_config = $HOME . "/.config/nvim"
let g:plugged_path = g:vim_config . "/plugged"

let mapleader = "\<space>"

"===============================================================================
"==================================[ plugins ]==================================
"===============================================================================
call plug#begin(g:plugged_path)

"=================================[ interface ]=================================
Plug 'altercation/vim-colors-solarized'                            " colorscheme
Plug 'hunter-/tester.vim'                                          " pair test files
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do': './install --all' } " install fzf
Plug 'junegunn/fzf.vim'                                            " fzf for vim
Plug 'tpope/vim-unimpaired'                                        " paired options
Plug 'w0rp/ale'                                                    " asynchronous lint engine

"================================[ text editing ]===============================
Plug 'AndrewRadev/splitjoin.vim' " join/split lines
Plug 'junegunn/vim-easy-align'   " align text at a separator
Plug 'justinmk/vim-sneak'        " 2char motions
Plug 'tpope/vim-commentary'      " comment language-agnostically
Plug 'tpope/vim-speeddating'     " smarter date logic
Plug 'tpope/vim-surround'        " deal with pairs
Plug 'wellle/targets.vim'        " more text objects
Plug 'zirrostig/vim-schlepp'     " move lines around
Plug 'SirVer/ultisnips'          " snippet engine
Plug 'honza/vim-snippets'        " predefined snippets

"====================================[ tmux ]===================================
Plug 'christoomey/vim-tmux-navigator'     " move seamlessly between tmux/vim splits
Plug 'roxma/vim-tmux-clipboard'           " paste between vim windows in different tmux spots
Plug 'tmux-plugins/vim-tmux-focus-events' " focus events for tmux+vim
Plug 'wellle/tmux-complete.vim'           " autocomplete across tmux panes

"==============================[ language/syntax ]==============================
Plug 'mustache/vim-mustache-handlebars', { 'for' : 'mustache' } " mustache
Plug 'tmux-plugins/vim-tmux', { 'for' : 'tmux' }                " tmux
Plug 'tpope/vim-markdown', { 'for' : 'markdown' }               " markdown; supports conceal
Plug 'vim-perl/vim-perl', { 'for' : 'perl' }                    " perl

"==================================[ writing ]==================================
Plug 'junegunn/goyo.vim', " distraction free + centered editing
Plug 'reedes/vim-pencil', " autowrap lines

"==================================[ testing ]==================================
Plug 'wellle/visual-split.vim'     " opening specific-sized splits
Plug 'reedes/vim-textobj-sentence' " improved sentence object
Plug 'shougo/denite.nvim'          " meta-whackness 10
Plug 'Glench/Vim-Jinja2-Syntax'
" Plug 'sts10/vim-zipper'			   " better folding?

call plug#end()

" fzf
let g:fzf_action = { 'ctrl-l': 'vsplit', 'ctrl-j': 'split' }

" pencil
let g:pencil#textwidth = 80

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

" arrange splits "verticalsplit" style
nnoremap <c-w>1 <c-w>H

" arrange splits "split" style
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

" save more easily
nnoremap <leader>w :w<cr>

" Conditionally modify character at end of line
nnoremap <silent> <leader>, :call lib#ModifyLineEndDelimiter(',')<cr>
nnoremap <silent> <leader>; :call lib#ModifyLineEndDelimiter(';')<cr>

" search files more easily
nnoremap \ :Ag<SPACE>

" grep for current word
nnoremap <silent> K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" 'do' mappings
nnoremap <leader>dd<space> :Denite 
nnoremap <leader>df :FZF<cr>
nnoremap <leader>dg :Goyo<cr>
nnoremap <leader>dw :call lib#UnstructuredText()<cr>
nnoremap <leader>dn :Neomake<cr>
nnoremap <leader>dp :PencilToggle<cr>
nnoremap <leader>dtj :call g:tester.OpenPairedFile()<cr>
nnoremap <leader>dtl :call g:tester.OpenPairedFile('vs')<cr>
nnoremap <leader>du :UltiSnipsEdit<cr>

"================================[ insert mode ]================================

" don't cancel iabbrevs on mode exit
imap <c-c> <esc>

" forward delete (consistent with osx at large)
inoremap <c-d> <del>

" untab/retab (default mapping used above)
inoremap <c-l> <c-t>
inoremap <c-h> <c-d>

" close various structures automatically
" newline
inoremap (<cr> (<cr>)<esc>O
inoremap [<cr> [<cr>]<esc>O
inoremap {<cr> {<cr>}<esc>O
inoremap <<cr> <<cr>><esc>O

" semicolon
inoremap (; ();<esc>hi
inoremap [; [];<esc>hi
inoremap {; {};<esc>hi

" comma
inoremap (, (),<esc>hi
inoremap {, {},<esc>hi
inoremap [, [],<esc>hi
inoremap ', '',<esc>hi
inoremap ", "",<esc>hi
inoremap `, ``,<esc>hi

" tab
inoremap (<tab> ()<esc>i
inoremap [<tab> []<esc>i
inoremap {<tab> {}<esc>i
inoremap <<tab> <><esc>i
inoremap '<tab> ''<esc>i
inoremap "<tab> ""<esc>i
inoremap `<tab> ``<esc>i

" TODO: add in markdown-specific remaps for italics ('__'), bold ('____')

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
augroup startupgroup
	autocmd!

	autocmd BufEnter,FocusGained * :call lib#NumberToggle(1)
	autocmd BufLeave,FocusLost * :call lib#NumberToggle(0)

	autocmd FileType markdown set conceallevel=2
	autocmd FileType markdown set concealcursor="nvc"
	autocmd FileType markdown,text set nofoldenable

	if empty(g:plugged_path)
		autocmd! VimEnter * PlugInstall
	endif
augroup END

"===============================================================================
"===============================[ abbreviations ]===============================
"===============================================================================
" TODO: move to ultisnips so abbreviations are tab-triggered
"==========[ insert mode ]==========
iabbrev _sdate <c-r>=strftime("%Y/%m/%d")<cr>
iabbrev _date <c-r>=strftime("%m/%d/%y")<cr>

"===============================================================================
"==================================[ commands ]=================================
"===============================================================================

command! -nargs=0 Text call lib#UnstructuredText()

command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

command! -nargs=1 H call lib#ShowHelp(<f-args>)

"====================[ load local vimrc ]====================
let s:local_vimrc = expand("~/.vimrc_local")
if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
endif

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
"==================================[ testing ]==================================
"===============================================================================

" open last window in split/vsplit
" nnoremap <c-s-l> :vsb#<cr>
" nnoremap <c-s-j> :sb#<cr>

" inoremap jf <esc>
" vnoremap jf <esc>

