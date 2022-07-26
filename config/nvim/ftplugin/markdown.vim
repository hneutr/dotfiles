let g:vim_markdown_no_default_key_mappings = 1

let g:projectFileName = '.project'

let g:mirrorDefaultsPath = "/Users/hne/Documents/research/hnetext/data/mirror-defaults.json"

let g:fileOpeningPrefix = "<leader>o"
let g:makePrefix = "<leader>m"
let g:scratchPrefix = "<leader>s"

"==================================[ projects ]=================================
command! Push call lex#project#pushChanges()

"==================================[ journals ]=================================
command! Journal call lib#openPath(lex#journals#getJournalFilePath())
command! WJournal call lib#openPath(lex#journals#getJournalFilePath(g:onlexJournal))

"===================================[ goals ]===================================
command! Goals call lib#openPath(lex#goals#getGoalsPath())

"==================================[ scratch ]==================================
" delete the currently selected lines and move them to the scratch file
nnoremap <silent> <leader>s :call lex#scratch#moveToScratchFile()<cr>
vnoremap <silent> <leader>s :'<,'>call lex#scratch#moveToScratchFile()<cr>

"==================================[ indexes ]==================================
call lex#map#mapPrefixedFileOpeners("g", "lex#index#openIndex")
command! Index call lib#openPath(lex#index#makeIndex(), "edit")

"==================================[ markers ]==================================
call lex#map#mapPrefixedFileOpeners("n", "lex#markers#gotoReference")
nnoremap <silent> <leader>g :call lex#markers#fuzzy("lex#markers#gotoPickSink")<cr>
nnoremap <silent> <M-l> :call lex#markers#gotoLocation("vsplit")<cr>
nnoremap <silent> <M-j> :call lex#markers#gotoLocation("split")<cr>
nnoremap <silent> <M-o> :call lex#markers#gotoLocation("edit")<cr>

" insert a header for a marker
nnoremap <silent> <leader>mm :call lex#dividers#insertMarkerHeader()<cr>
nnoremap <silent> <leader>ml :call lex#dividers#insertMarkerHeader()<cr>
nnoremap <silent> <leader>mb :call lex#dividers#insertMarkerHeader("big")<cr>

" "marker-reference" create a reference to the mark on the current line
nnoremap <silent> <leader>mr :let @" = lex#markers#getRef()<cr>

" "file-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :let @" = lex#markers#getRef('')<cr>

" search for markers
nnoremap <silent> <leader>fn /^[>#] \[.*\]()<cr>
nnoremap <silent> <leader>fN ?^[>#] \[.*\]()<cr>

"===========================[ fuzzy-find references ]===========================
nnoremap <silent> <leader>m/ :call lex#markers#fuzzy("lex#markers#putPickSink")<cr>
"  is <c-/> (the mapping only works if it's the literal character)
inoremap <silent>  <c-o>:call lex#markers#fuzzy("lex#markers#putPickInInsertSink")<cr>

"===================================[ todos ]===================================
nnoremap <silent> <leader>td :call lex#todo#toggleDone("✓ ")<cr>
vnoremap <silent> <leader>td :'<,'>call lex#todo#toggleDone("✓ ")<cr>
nnoremap <silent> <leader>tq :call lex#todo#toggleDone("? ")<cr>
vnoremap <silent> <leader>tq :'<,'>call lex#todo#toggleDone("? ")<cr>
nnoremap <silent> <leader>tm :call lex#todo#toggleDone("~ ")<cr>
vnoremap <silent> <leader>tm :'<,'>call lex#todo#toggleDone("~ ")<cr>
