let g:journalFilePath = writing#journals#getJournalFilePath()

"===================================[ marks ]===================================

" "marker-/" search for a marker
nnoremap <silent> <leader>m/ :call writing#markers#GoToMarkerReference("edit")<cr>
nnoremap <silent> <leader>ml :call writing#markers#GoToMarkerReference("vsplit")<cr>
nnoremap <silent> <leader>mj :call writing#markers#GoToMarkerReference("split")<cr>

" "marker-reference" create a cross-file reference to the mark on the current line.
nnoremap <silent> <leader>mc :call writing#markers#MakeMarkerReference()<cr>

" "path-marker-reference" create a file-reference to the current file
nnoremap <silent> <leader>mf :call writing#markers#MakeFileReference()<cr>

"==================================[ scratch ]==================================

" "scratch-open" open the scratch file (if in the non-scratch file) or open
" the non-scratch file (if in the scratch file)
nnoremap <silent> <leader>so :call writing#scratch#openScratchFile("edit")<cr>
nnoremap <silent> <leader>sl :call writing#scratch#openScratchFile("vsplit")<cr>
nnoremap <silent> <leader>sj :call writing#scratch#openScratchFile("split")<cr>

" "scratch-move" delete the currently selected lines and move them to the
" scratch file
nnoremap <silent> <leader>sm :call writing#scratch#moveToScratchFile()<cr>
vnoremap <silent> <leader>sm :'<,'>call writing#scratch#moveToScratchFile()<cr>

"==================================[ journals ]=================================
nnoremap <silent> <leader>jo :call writing#journals#openJournal("edit")<cr>
nnoremap <silent> <leader>jl :call writing#journals#openJournal("vsplit")<cr>
nnoremap <silent> <leader>jj :call writing#journals#openJournal("split")<cr>
