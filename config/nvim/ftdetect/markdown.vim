augroup markdown_startup
	autocmd!
	
	au BufNewFile,BufRead *.md call writing#project#setProjectRoot()

	" highlight done todos like comments
	au BufNewFile,BufRead *.md syn match doneTodo /^\s*✓.*/ containedin=ALL contains=mkdLink
	au BufNewFile,BufRead *.md hi link doneTodo Comment

	au TextChanged,InsertLeave *.md call writing#markers#updateReferencesOnLabelChange()
augroup END
