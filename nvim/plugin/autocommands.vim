augroup startup
	autocmd!

	" disable diagnostics support, fucking hate diagnostics
	autocmd BufEnter * lua vim.diagnostic.disable()

	" save whenever things change
	autocmd TextChanged,InsertLeave * lua require'util'.save_and_restore_visual_selection_marks()

	" turn numbers on for normal buffers; turn them off for terminal buffers
	autocmd TermOpen,BufWinEnter * lua require'util'.set_number_display()

	" enter insert mode whenever we're in a terminal
	autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert

	" open file at last point
	autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
