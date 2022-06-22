augroup markdown_startup
	autocmd!
	
	" set the project root
	au BufNewFile,BufRead *.md call lib#setProjectRoot()
augroup END
