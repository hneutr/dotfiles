"==========[ general ]==========

set dictionary="/usr/dict/words"
set lazyredraw
set tildeop	" tilde should be an operator

"==========[ interface ]==========
set noerrorbells
set novisualbell
set nowrap
set number
set showcmd
set shortmess=ac
set showmatch     " highlight matching braces
set timeoutlen=1000
set ttimeoutlen=0 " no pause on esc

"==========[ misc display ]==========
set background=dark
colorscheme solarized

" SignColumn should be same color as line number column
highlight clear SignColumn

"==========[ files ]==========
set autowriteall
set fileformats=unix,dos,mac
set noswapfile
set undofile
set undodir=~/.vim/undodir

"==========[ indentation ]==========
set smartindent
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
set inccommand=nosplit

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
set statusline=%.100F " Full path (100 chars)
set statusline+=%=    " right side
set statusline+=%c    " column

highlight statusline ctermfg=0
highlight statusline ctermbg=14

"==========[ cursor ]==========
set nocursorline
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,
	\i-ci:ver25-Cursor/lCursor,
	\r-cr:hor20-Cursor/lCursor

"==========[ folds ]==========
set foldenable
set foldmethod=indent
set foldnestmax=1
set foldtext=lib#FoldDisplayText()

highlight Folded cterm=NONE

"==========[ vimgrep ]==========
if executable('ag')
	set grepprg=ag\ --vimgrep
endif
