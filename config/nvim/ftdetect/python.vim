autocmd BufRead,BufNewFile, *.py nnoremap <buffer> <silent> <leader>; :call lib#ModifyLineEndDelimiter(':')<cr>
