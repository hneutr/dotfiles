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

" I don't use ex mode; play last macro
nnoremap Q @@

" yank to end of line; consistency is king
nnoremap Y y$

" change case of character under cursor
nnoremap ~~ ~l

" turn off highlighting
nnoremap <silent> <leader><space> :nohlsearch<cr>

" edit and load vimrc
nnoremap <leader>vv :sp $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>:nohlsearch<cr>

" don't store "{"/"}" motions in jump list
nnoremap <silent> } :<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>
nnoremap <silent> { :<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>

" remove trailing whitespace
nnoremap <leader>w :%s/\s\+$//<cr>nohlsearch<cr>

" Conditionally modify character at end of line
nnoremap <silent> <leader>, :call ModifyLineEndDelimiter(',')<cr>
nnoremap <silent> <leader>; :call ModifyLineEndDelimiter(';')<cr>

"==========[ insert ]==========

" don't cancel iabbrevs on exit
imap <c-c> <esc>

" more intuitive untab/retab
inoremap <c-l> <c-t>
inoremap <c-h> <c-d>

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

"==========[  ]==========
