augroup startup
	autocmd!

	autocmd VimEnter * call lib#setListenAddress()

	" save whenever things change
	autocmd TextChanged,InsertLeave * call lib#SaveAndRestoreVisualSelectionMarks()

	" turn numbers on for normal buffers; turn them off for terminal buffers
	autocmd TermOpen,BufWinEnter * call lib#SetNumberDisplay()

	" enter insert mode whenever we're in a terminal
	autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert
augroup END
