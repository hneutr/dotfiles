" quickly edit macros
nnoremap <leader>m :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" more intuitive completion mappings
inoremap <c-j> <c-n>
inoremap <c-k> <c-p>
inoremap <c-u> <c-x><c-u>
inoremap <c-f> <c-x><c-f>
inoremap <c-]> <c-x><c-]>
inoremap <c-l> <c-x><c-l>
