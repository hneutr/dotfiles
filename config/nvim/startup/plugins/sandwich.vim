let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1

" I use sneak more than sandwich, and I only ever use qq;
" map sandwich bindings to q<etc>

" add
silent! nmap <unique> qa <Plug>(operator-sandwich-add)
silent! xmap <unique> qa <Plug>(operator-sandwich-add)
silent! omap <unique> qa <Plug>(operator-sandwich-g@)

" delete
silent! xmap <unique> qd <Plug>(operator-sandwich-delete)

" replace
silent! xmap <unique> qr <Plug>(operator-sandwich-replace)

" combos
silent! nmap <unique><silent> qd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> qr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> qdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
silent! nmap <unique><silent> qrb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
