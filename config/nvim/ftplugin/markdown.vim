let g:vim_markdown_no_default_key_mappings = 1

"==================================[ projects ]=================================
command! Push call writing#project#pushChanges()

"==================================[ outlines ]=================================
call writing#project#addFileOpeningMappings('o', g:outlinesPrefix)

"===============================[ possibilities ]===============================
call writing#project#addFileOpeningMappings('p', g:possibilitiesPrefix)

"==================================[ changes ]==================================
call writing#project#addFileOpeningMappings('c', g:changesPrefix)

"=================================[ fragments ]=================================
call writing#project#addFileOpeningMappings('f', g:fragmentsPrefix)

"==================================[ scratch ]==================================
call writing#project#addFileOpeningMappings('s', g:scratchPrefix)

" delete the currently selected lines and move them to the scratch file
nnoremap <silent> <leader>sm :call writing#scratch#moveToScratchFile()<cr>
vnoremap <silent> <leader>sm :'<,'>call writing#scratch#moveToScratchFile()<cr>

"==================================[ journals ]=================================
command! Journal call lib#openPath(writing#journals#getJournalFilePath())
command! WJournal call lib#openPath(writing#journals#getJournalFilePath(g:onWritingJournal))

"===================================[ goals ]===================================
command! Goals call lib#openPath(writing#goals#getGoalsPath())

"==================================[ indexes ]==================================
call lib#mapPrefixedFileOpeningActions("i", "writing#index#openIndex")
command! Index call lib#openPath(writing#index#makeIndex(), "edit")

"==================================[ markers ]==================================
call lib#mapPrefixedFileOpeningActions("m", "writing#markers#gotoReference")
nnoremap <silent> <leader>m/o :call writing#markers#pickReference("writing#markers#editPick")<cr>
nnoremap <silent> <leader>m/l :call writing#markers#pickReference("writing#markers#vsplitPick")<cr>
nnoremap <silent> <leader>m/j :call writing#markers#pickReference("writing#markers#splitPick")<cr>

" "marker-reference" create a reference to the mark on the current line
nnoremap <silent> <leader>mr :call writing#markers#getReference()<cr>

" "file-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :call writing#markers#getFileReference()<cr>

" search for markers
nnoremap <silent> <leader>mn /^[>#] \[.*\]()<cr>
nnoremap <silent> <leader>mN ?^[>#] \[.*\]()<cr>

" insert a header for a marker
nnoremap <silent> <leader>mh :call writing#dividers#insertMarkerHeader()<cr>
nnoremap <silent> <leader>mbh :call writing#dividers#insertMarkerHeader("big")<cr>

" change a marker's label
command! -nargs=1 RelabelMarker call writing#markers#renameMarker(<f-args>)

"===========================[ fuzzy-find references ]===========================
nnoremap <silent> <leader>r :call writing#markers#pickReference()<cr>
