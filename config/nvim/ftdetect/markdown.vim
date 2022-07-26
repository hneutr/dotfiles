augroup markdown_startup
	autocmd!
	
	au BufNewFile,BufRead *.md call lex#project#setProjectRoot()
	au TextChanged,InsertLeave *.md call lex#markers#updateReferencesOnLabelChange()


	au BufNewFile,BufRead *.md call lex#sync#bufEnter()
	au TextChanged,InsertLeave *.md call lex#sync#bufChange()
	au BufLeave,VimLeave *.md call lex#sync#bufLeave()

	" au TextYankPost *.md call lex#markers#parseYankedMarkers(v:event)

	" could find markers to parse based on BufEnter and BufLeave/VimQuit
	" same for lex#markers#updateReferencesOnLabelChange...
augroup END
