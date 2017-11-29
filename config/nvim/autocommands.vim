augroup startup
	autocmd!

	" turn off the status bar when fzf is running
	autocmd FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2

	" save whenever things change
	autocmd TextChanged,InsertLeave * call lib#SaveAndRestoreVisualSelectionMarks()

	" turn numbers on for normal buffers; turn them off for terminal buffers
	autocmd TermOpen,BufFilePost * call lib#SetNumberDisplay()

	" use relative numbers for focused area (maybe turn this back on with a
	" check for if number is turned on or not?)
	" autocmd BufEnter,FocusGained * call lib#NumberToggle(1)
	" autocmd BufLeave,FocusLost * call lib#NumberToggle(0)

	" enter insert mode whenever we're in a terminal
	autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert
augroup END
