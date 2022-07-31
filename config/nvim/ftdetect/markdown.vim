augroup markdown_startup
	autocmd!

	au BufNewFile,BufRead *.md set ft=markdown
	au BufNewFile,BufRead *.md let g:vim_markdown_no_default_key_mappings = 1
	
	au BufNewFile,BufRead *.md lua require'lex.project'.set_root()

	au BufEnter *.md lua require'lex.sync'.buf_enter()
	au TextChanged,InsertLeave *.md lua require'lex.sync'.buf_change()
	au BufLeave,VimLeave *.md lua require'lex.sync'.buf_leave()
augroup END
