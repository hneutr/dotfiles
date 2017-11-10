"==================================[ settings ]=================================
" magic to make italics and bold show up
set conceallevel=2
set concealcursor="nvc"

" wrap overlong lines (aka paragraphs)
set wrap

" break at words
set linebreak

"==================================[ mappings ]=================================
" with markdown files I usually want to go to the end of the "visual" line,
" not the end of the wrapped line
nnoremap g^ ^
nnoremap g$ $
nnoremap ^ g^
nnoremap $ g$

nnoremap <leader>h g^
nnoremap <leader>l g$
