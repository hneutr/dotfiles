augroup startup
	autocmd!

	" use relative numbers for focused area
	" autocmd BufEnter,FocusGained * call lib#NumberToggle(1)
	" autocmd BufLeave,FocusLost * call lib#NumberToggle(0)

	" save whenever things change
	autocmd TextChanged,TextChangedI * call lib#SaveAndRestoreVisualSelectionMarks()

	" turn off numbers in terminal mode
	autocmd TermOpen * setlocal nonumber
	autocmd TermOpen * setlocal norelativenumber
	autocmd TermOpen * setlocal scrolloff=0

	" enter insert mode whenever we're in a terminal
	autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert
augroup END
