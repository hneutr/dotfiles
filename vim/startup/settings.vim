"==========[ general ]==========
let mapleader="\<space>"

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

"==========[ display ]==========

highlight statusline ctermfg=0
highlight statusline ctermbg=14
set statusline=%.100F " Full path (100 chars)
set statusline+=%=    " right side
set statusline+=%c    " column

if has('nvim')
	" turn cursor into a '|' in insert mode
	set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,
				\i-ci:ver25-Cursor/lCursor,
				\r-cr:hor20-Cursor/lCursor
endif

