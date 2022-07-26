augroup markdown_startup
	autocmd!
	
	au BufNewFile,BufRead *.md call lex#project#setProjectRoot()

	" sync renamed/moved references
	au BufNewFile,BufRead *.md call lex#sync#bufEnter()
	au TextChanged,InsertLeave *.md call lex#sync#bufChange()
	au BufLeave,VimLeave *.md call lex#sync#bufLeave()

augroup END
