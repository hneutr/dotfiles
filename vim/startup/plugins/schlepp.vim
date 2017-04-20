" allow removing tabs when they are uneven
let g:Schlepp#allowSquishingLines = 1
let g:Schlepp#allowSquishingBlocks = 1

" reindent when moving
let g:Schlepp#reindent = 1

" map toggle reindent
vmap t <Plug>SchleppToggleReindent

vmap <up>    <Plug>SchleppUp
vmap <down>  <Plug>SchleppDown
vmap <left>  <Plug>SchleppLeft
vmap <right> <Plug>SchleppRight
