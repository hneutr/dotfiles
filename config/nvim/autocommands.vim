augroup startup
	autocmd!

	" use relative numbers for focused area
	" autocmd BufEnter,FocusGained * call lib#NumberToggle(1)
	" autocmd BufLeave,FocusLost * call lib#NumberToggle(0)

	" turn off the status bar when fzf is running
	autocmd FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2


	" save whenever things change
	autocmd TextChanged,InsertLeave * call lib#SaveAndRestoreVisualSelectionMarks()

	" turn off numbers in terminal mode
	autocmd TermOpen * setlocal nonumber
	autocmd TermOpen * setlocal norelativenumber
	autocmd TermOpen * setlocal scrolloff=0

	" enter insert mode whenever we're in a terminal
	autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert
augroup END
