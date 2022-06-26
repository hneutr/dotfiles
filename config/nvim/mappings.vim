let mapleader = "\<space>"
let maplocalleader = "\<space>"
" this is the prefix I use to "namespace" plugin mappings
let g:pluginleader = "<leader>d"

"================================[ normal mode ]================================
" yank to end of line (match C/D)
nnoremap Y y$

" select what was last pasted/visually selected
nnoremap gV `[v`]

" swap */# (match _W_ord) and g*/g# (match _w_ord)
nnoremap * g*
nnoremap g* *
nnoremap # g#
nnoremap g# #

" restore cursor position after joining lines
nnoremap J mjJ`j

" play 'q' macro (I mostly just use the 'q' macro)
nnoremap Q @q

" don't store "{"/"}" motions in jump list
nnoremap <silent> } :<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>
nnoremap <silent> { :<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>

" mark before searching (p = "previous")
nnoremap / mp/
nnoremap ? mp?

" move to end/start of line easily
nnoremap <space>l $
nnoremap <space>h ^

" Conditionally modify character at end of line
nnoremap <silent> <leader>, :call lib#ModifyLineEndDelimiter(',')<cr>
nnoremap <silent> <leader>; :call lib#ModifyLineEndDelimiter(';')<cr>

" run last command easily
nnoremap <leader>c :<c-p><cr>

" quit with an arpeggiation (save the pinky)
nnoremap <leader>q :q<cr>

" kill the buffer with an arpeggiation (stp)
nnoremap <silent> <leader>k :call lib#KillBufferAndGoToNext()<cr>

" switch buffers with tab/s-tab
nnoremap <tab> :bn<cr>
nnoremap <s-tab> :bp<cr>

" <BS> is useless in normal mode; map it to gE
nnoremap <BS> gE

"================================[ insert mode ]================================
inoremap <nowait> <esc> <esc>

" save the pinky
inoremap jk <esc>
inoremap <c-c> <nop>

" why would I want to delete only until the start of insert mode? why?
inoremap <c-w> <c-\><c-o>db

" forward delete to end of word
inoremap <c-s> <c-\><c-o>de

" forward delete (consistent with osx)
inoremap <c-d> <del>

" change indent
inoremap <c-h> <c-d>
inoremap <c-l> <c-t>

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
inoremap $<tab> $$<esc>i

" digraphs are good
inoremap <M--> —
inoremap <M-=> ≠

" move to end of line
inoremap <c-a> <c-o>A

"================================[ visual mode ]================================
" keep visual selection after indent/unindent
vnoremap > >gv
vnoremap < <gv

"==========================[ normal and visual modes ]==========================
" switch panes
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

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

" make n (N) always go forward (backward); recenter after jumping
nnoremap <expr> n 'Nn'[v:searchforward].'zz'
vnoremap <expr> n 'Nn'[v:searchforward].'zz'
nnoremap <expr> N 'nN'[v:searchforward].'zz'
vnoremap <expr> N 'nN'[v:searchforward].'zz'

" use enter as colon for faster commands
nnoremap <cr> :
vnoremap <cr> :

"================================[ command mode ]===============================
" make start of line and end of line movements match zsh/bash
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Move by word
cnoremap <m-b> <s-left>
cnoremap <m-f> <s-right>

" make commandline history smarter (use text entered so far)
cnoremap <c-n> <down>
cnoremap <c-p> <up>

"==================================[ terminal ]=================================
" I like to get out with one key
tnoremap <esc> <c-\><c-n>
tnoremap <c-[> <c-\><c-n>

" consistent window movement commands
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l

" make <c-r> work like in insert mode
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

"==================================[ operator ]=================================

" visually select the whole buffer
onoremap A :<C-U>normal! mzggVG<CR>`z
xnoremap A :<C-U>normal! mzggVG<CR>`z
