let g:vim_markdown_no_default_key_mappings = 1

let g:projectFileName = '.project'

let g:mirrorDefaultsPath = "/Users/hne/Documents/research/hnetext/data/mirror-defaults.json"

let g:fileOpeningPrefix = "<leader>o"
let g:makePrefix = "<leader>m"
let g:scratchPrefix = "<leader>s"

"==================================[ projects ]=================================
command! Push call writing#project#pushChanges()

"==================================[ journals ]=================================
command! Journal call lib#openPath(writing#journals#getJournalFilePath())
command! WJournal call lib#openPath(writing#journals#getJournalFilePath(g:onWritingJournal))

"===================================[ goals ]===================================
command! Goals call lib#openPath(writing#goals#getGoalsPath())

"==================================[ scratch ]==================================
" delete the currently selected lines and move them to the scratch file
nnoremap <silent> <leader>s :call writing#scratch#moveToScratchFile()<cr>
vnoremap <silent> <leader>s :'<,'>call writing#scratch#moveToScratchFile()<cr>

"==================================[ indexes ]==================================
call writing#map#mapPrefixedFileOpeners("g", "writing#index#openIndex")
command! Index call lib#openPath(writing#index#makeIndex(), "edit")

"==================================[ markers ]==================================
call writing#map#mapPrefixedFileOpeners("n", "writing#markers#gotoReference")
nnoremap <silent> <leader>g :call writing#markers#fuzzy("writing#markers#gotoPickSink")<cr>
nnoremap <silent> <M-l> :call writing#markers#gotoReference("vsplit")<cr>
nnoremap <silent> <M-j> :call writing#markers#gotoReference("split")<cr>
nnoremap <silent> <M-o> :call writing#markers#gotoReference("edit")<cr>

" insert a header for a marker
nnoremap <silent> <leader>mm :call writing#dividers#insertMarkerHeader()<cr>
nnoremap <silent> <leader>ml :call writing#dividers#insertMarkerHeader()<cr>
nnoremap <silent> <leader>mb :call writing#dividers#insertMarkerHeader("big")<cr>

" "marker-reference" create a reference to the mark on the current line
nnoremap <silent> <leader>mr :call writing#markers#getReference()<cr>

" "file-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :call writing#markers#getFileReference()<cr>

" search for markers
nnoremap <silent> <leader>fn /^[>#] \[.*\]()<cr>
nnoremap <silent> <leader>fN ?^[>#] \[.*\]()<cr>

" change a marker's label
command! -nargs=1 RelabelMarker call writing#markers#renameMarker(<f-args>)

" make a reference into a marker
command! RefToMarker call writing#markers#refToMarker()

"===========================[ fuzzy-find references ]===========================
nnoremap <silent> <leader>m/ :call writing#markers#fuzzy("writing#markers#putPickSink")<cr>
"  is <c-/> (the mapping only works if it's the literal character)
inoremap <silent>  <c-o>:call writing#markers#fuzzy("writing#markers#putPickInInsertSink")<cr>

"===================================[ todos ]===================================
nnoremap <silent> <leader>td :call writing#todo#toggleDone("✓ ")<cr>
vnoremap <silent> <leader>td :'<,'>call writing#todo#toggleDone("✓ ")<cr>
nnoremap <silent> <leader>tq :call writing#todo#toggleDone("? ")<cr>
vnoremap <silent> <leader>tq :'<,'>call writing#todo#toggleDone("? ")<cr>
