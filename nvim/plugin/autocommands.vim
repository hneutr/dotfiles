augroup startup
	autocmd!

	autocmd VimEnter * call lib#setListenAddress()

	" disable diagnostics support, fucking hate diagnostics
	autocmd BufEnter * lua vim.diagnostic.disable()

	" save whenever things change
	autocmd TextChanged,InsertLeave * call lib#SaveAndRestoreVisualSelectionMarks()

	" turn numbers on for normal buffers; turn them off for terminal buffers
	autocmd TermOpen,BufWinEnter * call lib#SetNumberDisplay()

	" enter insert mode whenever we're in a terminal
	autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert

	" open file at last point
	autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
