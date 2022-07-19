let g:vim_markdown_no_default_key_mappings = 1

let g:fileOpeningPrefix = "<leader>o"
let g:makePrefix = "<leader>m"
let g:scratchPrefix = "<leader>s"

let g:mirrors = {
			\ 'c': 'changes',
			\ 'f': '.fragments',
			\ 'd': 'ideas',
			\ 'o': 'outlines',
			\ 's': '.scratch',
			\ 'x': 'meta',
			\}

function s:addOpenMirrorMappings()
	for [prefix, directory] in items(g:mirrors)
		call writing#project#addFileOpeningMappings(prefix, directory)
	endfor
endfunction

call s:addOpenMirrorMappings()

" mirrors
let g:scratchPrefix = '.scratch'

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
call writing#map#mapPrefixedFileOpeners("i", "writing#index#openIndex")
command! Index call lib#openPath(writing#index#makeIndex(), "edit")

"==================================[ markers ]==================================
call writing#map#mapPrefixedFileOpeners("n", "writing#markers#gotoReference")
call writing#map#mapPrefixedFileOpeners("m", "writing#markers#pick", '', {'edit': "writing#markers#editPick"}) 
call writing#map#mapPrefixedFileOpeners("m", "writing#markers#pick", '', {'vsplit': "writing#markers#vsplitPick"}) 
call writing#map#mapPrefixedFileOpeners("m", "writing#markers#pick", '', {'split': "writing#markers#splitPick"}) 

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
nnoremap <silent> <leader>m/ :call writing#markers#pick()<cr>
"  is <c-/> (the mapping only works if it's the literal character)
inoremap <silent>  <c-o>:call writing#markers#pick("writing#markers#putPickInInsert")<cr>

"===================================[ todos ]===================================
nnoremap <silent> <leader>t :call writing#todo#toggleDone()<cr>
vnoremap <silent> <leader>t :'<,'>call writing#todo#toggleDone()<cr>
