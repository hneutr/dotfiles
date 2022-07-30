augroup markdown_startup
	autocmd!

	au BufNewFile,BufRead *.md set ft=markdown
	au BufNewFile,BufRead *.md let g:vim_markdown_no_default_key_mappings = 1
	
	au BufNewFile,BufRead *.md lua require'lex.project'.set_root()

	" sync renamed/moved references
	au BufEnter *.md call lex#sync#bufEnter()
	au TextChanged,InsertLeave *.md call lex#sync#bufChange()
	au BufLeave,VimLeave *.md call lex#sync#bufLeave()
augroup END
