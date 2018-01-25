"==================================[ settings ]=================================
" magic to make italics and bold show up
set conceallevel=2
set concealcursor="nvc"

" break at words
set linebreak

" cindent isn't very useful in prose
set nocindent

"==================================[ mappings ]=================================
" with markdown files I usually want to go to the end of the "visual" line,
" not the end of the wrapped line
nnoremap g^ ^
nnoremap g$ $
nnoremap ^ g^
nnoremap $ g$

nnoremap <leader>h g^
nnoremap <leader>l g$
