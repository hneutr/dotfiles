let g:journalFilePath = writing#journals#getJournalFilePath()
let g:goalsFilePath = writing#goals#getGoalsFilePath()

"==================================[ projects ]=================================
nnoremap <silent> <leader>gu :call writing#project#pushChanges()<cr>

"===================================[ marks ]===================================

" "marker-/" search for a marker
nnoremap <silent> <leader>m/ :call writing#markers#GoToMarkerReference("edit")<cr>
call lib#mapPrefixedFileOpeningActions("m", "writing#markers#GoToMarkerReference")

" "marker-reference" create a cross-file reference to the mark on the current line.
nnoremap <silent> <leader>mc :call writing#markers#MakeMarkerReference()<cr>

" "file-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :call writing#markers#MakeFileReference()<cr>

" search for markers
nnoremap <silent> <leader>mn /^[>#] \[.*\]()<cr>
nnoremap <silent> <leader>mN ?^[>#] \[.*\]()<cr>

"==================================[ scratch ]==================================
call writing#project#addFileOpeningMappings('s', g:scratchPrefix)

" delete the currently selected lines and move them to the scratch file
nnoremap <silent> <leader>sm :call writing#scratch#moveToScratchFile()<cr>
vnoremap <silent> <leader>sm :'<,'>call writing#scratch#moveToScratchFile()<cr>

"==================================[ outlines ]=================================
call writing#project#addFileOpeningMappings('o', g:outlinesPrefix)

"==================================[ journals ]=================================
call lib#mapPrefixedFileOpeningActions("j", "lib#openPath", '"' . g:journalFilePath . '"')

"===================================[ goals ]===================================
call lib#mapPrefixedFileOpeningActions("g", "lib#openPath", '"' . g:goalsFilePath . '"')

"==================================[ indexes ]==================================
call lib#mapPrefixedFileOpeningActions("i", "writing#index#toggleIndex")
" directory indexes
call lib#mapPrefixedFileOpeningActions("id", "writing#index#toggleDirectoryIndex")

" insert the file index into the current file
nnoremap <silent> <leader>if :call writing#index#insertIndex()<cr>
nnoremap <silent> <leader>idf :call writing#index#insertIndex("directory")<cr>
nnoremap <silent> <leader>ib :call writing#index#insertIndex("both")<cr>
