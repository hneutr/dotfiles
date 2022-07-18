augroup markdown_startup
	autocmd!
	
	" set the project root
	au BufNewFile,BufRead *.md call writing#project#setProjectRoot()
	au TextChanged,InsertLeave *.md call writing#markers#updateReferencesOnLabelChange()
augroup END
