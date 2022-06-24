let g:journalFilePath = writing#journals#getJournalFilePath()

"==================================[ projects ]=================================
nnoremap <silent> <leader>pu :call writing#project#pushChanges()<cr>

"===================================[ marks ]===================================

" "marker-/" search for a marker
nnoremap <silent> <leader>m/ :call writing#markers#GoToMarkerReference("edit")<cr>
nnoremap <silent> <leader>ml :call writing#markers#GoToMarkerReference("vsplit")<cr>
nnoremap <silent> <leader>mj :call writing#markers#GoToMarkerReference("split")<cr>

" "marker-reference" create a cross-file reference to the mark on the current line.
nnoremap <silent> <leader>mc :call writing#markers#MakeMarkerReference()<cr>

" "file-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :call writing#markers#MakeFileReference()<cr>

" search for markers
nnoremap <silent> <leader>mn /^[>#] \[.*\]()<cr>
nnoremap <silent> <leader>mN ?^[>#] \[.*\]()<cr>

"==================================[ scratch ]==================================

" "scratch-open" open the scratch file (if in the non-scratch file) or open
" the non-scratch file (if in the scratch file)
nnoremap <silent> <leader>so :call writing#project#switchBetweenPathAndPrefixedPath(g:scratchPrefix)<cr>
nnoremap <silent> <leader>sl :call writing#project#switchBetweenPathAndPrefixedPath(g:scratchPrefix, "vsplit")<cr>
nnoremap <silent> <leader>sj :call writing#project#switchBetweenPathAndPrefixedPath(g:scratchPrefix, "split")<cr>

" "scratch-move" delete the currently selected lines and move them to the
" scratch file
nnoremap <silent> <leader>sm :call writing#scratch#moveToScratchFile()<cr>
vnoremap <silent> <leader>sm :'<,'>call writing#scratch#moveToScratchFile()<cr>

"==================================[ journals ]=================================
nnoremap <silent> <leader>jo :call writing#journals#openJournal("edit")<cr>
nnoremap <silent> <leader>jl :call writing#journals#openJournal("vsplit")<cr>
nnoremap <silent> <leader>jj :call writing#journals#openJournal("split")<cr>

"==================================[ indexes ]==================================
nnoremap <silent> <leader>io :call writing#index#toggleIndex("edit")<cr>
nnoremap <silent> <leader>il :call writing#index#toggleIndex("vsplit")<cr>
nnoremap <silent> <leader>ij :call writing#index#toggleIndex("split")<cr>

" directory indexes
nnoremap <silent> <leader>ido :call writing#index#toggleDirectoryIndex("edit")<cr>
nnoremap <silent> <leader>idl :call writing#index#toggleDirectoryIndex("vsplit")<cr>
nnoremap <silent> <leader>idj :call writing#index#toggleDirectoryIndex("split")<cr>

" insert the file index into the current file
nnoremap <silent> <leader>if :call writing#index#insertIndex()<cr>
nnoremap <silent> <leader>idf :call writing#index#insertIndex("directory")<cr>
nnoremap <silent> <leader>ib :call writing#index#insertIndex("both")<cr>
