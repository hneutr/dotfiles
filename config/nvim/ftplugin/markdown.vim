let g:project_file_name = '.project'

let g:writing_journal = 'on-writing'

let g:mirror_defaults_path = "/Users/hne/Documents/research/hnetext/data/mirror-defaults.json"

let g:file_opening_prefix = "<leader>o"

"==================================[ projects ]=================================
command! Push lua require'lex.project'.push()

"==================================[ journals ]=================================
command! Journal lua require'util'.open_path(require'lex.journal'.path())
command! WJournal lua require'util'.open_path(require'lex.journal'.path(vim.g.writing_journal))

"===================================[ goals ]===================================
command! Goals lua require'util'.open_path(require'lex.goals'.path())

"==================================[ scratch ]==================================
" delete the currently selected lines and move them to the scratch file
nnoremap <silent> <leader>s :lua require'lex.scratch'.move('n')<cr>
vnoremap <silent> <leader>s :'<,'>lua require'lex.scratch'.move('v')<cr>

"==================================[ indexes ]==================================
lua require'lex.map'.map_prefixed_file_openers('g', ":lua require'lex.index'.open")
command! Index lua require'lex.index'.open()<cr>

"==================================[ markers ]==================================
lua require'lex.map'.map_prefixed_file_openers('n', ":call lex#markers#gotoLocation")
nnoremap <silent> <leader>f :call lex#markers#fuzzy("lex#markers#gotoPickSink")<cr>
nnoremap <silent> <M-l> :call lex#markers#gotoLocation("vsplit")<cr>
nnoremap <silent> <M-j> :call lex#markers#gotoLocation("split")<cr>
nnoremap <silent> <M-o> :call lex#markers#gotoLocation("edit")<cr>

" insert a header for a marker
nnoremap <silent> <leader>mm :lua require'lex.divider'.header.insert_marker()<cr>
nnoremap <silent> <leader>ml :lua require'lex.divider'.header.insert_marker()<cr>
nnoremap <silent> <leader>mb :lua require'lex.divider'.header.insert_marker("large")<cr>

" "marker-reference" create a reference to the mark on the current line
nnoremap <silent> <leader>mr :let @" = lex#markers#getRef()<cr>

" "file-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :let @" = lex#markers#getRef('')<cr>

" search for markers
" nnoremap <silent> <leader>fn /^[>#] \[.*\]()<cr>
" nnoremap <silent> <leader>fN ?^[>#] \[.*\]()<cr>

"===========================[ fuzzy-find references ]===========================
nnoremap <silent> <leader>m/ :call lex#markers#fuzzy("lex#markers#putPickSink")<cr>
"  is <c-/> (the mapping only works if it's the literal character)
inoremap <silent>  <c-o>:call lex#markers#fuzzy("lex#markers#putPickInInsertSink")<cr>

"===================================[ todos ]===================================
nnoremap <silent> <leader>td :lua require'lex.list_toggle'.toggle_item("✓", 'n')<cr>
vnoremap <silent> <leader>td :lua require'lex.list_toggle'.toggle_item("✓", 'v')<cr>
nnoremap <silent> <leader>tq :lua require'lex.list_toggle'.toggle_item("?", 'n')<cr>
vnoremap <silent> <leader>tq :lua require'lex.list_toggle'.toggle_item("?", 'v')<cr>
nnoremap <silent> <leader>tm :lua require'lex.list_toggle'.toggle_item("~", 'n')<cr>
vnoremap <silent> <leader>tm :lua require'lex.list_toggle'.toggle_item("~", 'v')<cr>
