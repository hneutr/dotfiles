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
lua require'lex.map'.map_prefixed_file_openers('n', ":lua require'lex.marker'.location.goto")
nnoremap <silent> <M-l> :lua require'lex.marker'.location.goto("vsplit")<cr>
nnoremap <silent> <M-j> :lua require'lex.marker'.location.goto("split")<cr>
nnoremap <silent> <M-o> :lua require'lex.marker'.location.goto("edit")<cr>

" insert a header for a marker
nnoremap <silent> <leader>mm :lua require'lex.divider'.header.insert_marker()<cr>
nnoremap <silent> <leader>ml :lua require'lex.divider'.header.insert_marker()<cr>
nnoremap <silent> <leader>mb :lua require'lex.divider'.header.insert_marker("large")<cr>

" "marker-reference" create a reference to the mark on the current line
nnoremap <silent> <leader>mr :lua vim.fn.setreg('"', require'lex.marker'.reference.get())<cr>

" "file-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :lua vim.fn.setreg('"', require'lex.marker'.reference.get({ text = "" }))<cr>

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
