" write even more
set autowriteall

set background=dark

" excluded completion types:
" ----> included files
set complete-=i
" ----> don't scan tags
set complete-=t

set dictionary="/usr/dict/words"

set fileformats=unix,dos,mac

" use rg if it is available
if executable('rg')
	set grepprg=rg\ --vimgrep
endif

" cursor magic:
" ----> normal, visual, command = block
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0
" ----> insert = vertical
set guicursor+=i-ci:ver25-Cursor/lCursor
" ----> replace + command-replace = underscore
set guicursor+=r-cr:hor20-Cursor/lCursor

" show results of a command while typing
set inccommand=nosplit

" redraw less
set lazyredraw

set nocursorline

set noerrorbells

" don't clutter with .swp files
set noswapfile

set novisualbell

set nowrap

set sidescroll=1

" messages:
" ----> shorten status updates
set shortmess=a
" ----> don't show completion messages
set shortmess+=c

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

" make h/l wrap around lines
" set whichwrap+=h,l

" ignore file types in completion
set wildignore+=.DS_Store,.git,*.tmp,*.swp,*.png,*.jpg,*.gif

set wildignorecase

set wildmode=list:longest,full

" visually wrap long lines
set wrap

"===================================[ folds ]===================================
set nofoldenable

set foldmethod=indent

" only fold 1 level
set foldnestmax=1

" custom fold function
set foldtext=lib#FoldDisplayText()

"================================[ indentation ]================================
set cindent

set shiftwidth=4

set softtabstop=4

set expandtab

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
