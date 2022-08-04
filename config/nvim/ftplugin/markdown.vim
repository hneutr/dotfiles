"==================================[ scratch ]==================================
" delete the currently selected lines and move them to the scratch file
nnoremap <silent> <leader>s :lua require'lex.scratch'.move('n')<cr>
vnoremap <silent> <leader>s :'<,'>lua require'lex.scratch'.move('v')<cr>

" insert a header for a marker
nnoremap <silent> <leader>mm :lua require'lex.divider'.header.insert_marker()<cr>
nnoremap <silent> <leader>ml :lua require'lex.divider'.header.insert_marker()<cr>
nnoremap <silent> <leader>mb :lua require'lex.divider'.header.insert_marker("large")<cr>

" "marker-reference" create a reference to the mark on the current line
nnoremap <silent> <leader>mr :lua vim.fn.setreg('"', require'lex.link'.Reference.from_str():str())<cr>

" "file-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :lua vim.fn.setreg('"', require'lex.link'.Reference.from_path():str() )<cr>

"===========================[ fuzzy-find references ]===========================
nnoremap <silent> <leader>f :call lex#fuzzy#start("lex#fuzzy#goto")<cr>
nnoremap <silent> <leader>m/ :call lex#fuzzy#start("lex#fuzzy#put")<cr>
"  is <c-/> (the mapping only works if it's the literal character)
inoremap <silent>  <c-o>:call lex#fuzzy#start("lex#fuzzy#insert_put")<cr>

"===================================[ todos ]===================================
nnoremap <silent> <leader>td :lua require'lex.list'.toggle_sigil('n', '✓')<cr>
vnoremap <silent> <leader>td :lua require'lex.list'.toggle_sigil('v', '✓')<cr>
nnoremap <silent> <leader>tq :lua require'lex.list'.toggle_sigil('n', '?')<cr>
vnoremap <silent> <leader>tq :lua require'lex.list'.toggle_sigil('v', '?')<cr>
nnoremap <silent> <leader>tm :lua require'lex.list'.toggle_sigil('n', '~')<cr>
vnoremap <silent> <leader>tm :lua require'lex.list'.toggle_sigil('v', '~')<cr>
