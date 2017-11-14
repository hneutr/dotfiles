augroup startup
	autocmd!

	" use relative numbers for focused area
	autocmd BufEnter,FocusGained * call lib#NumberToggle(1)
	autocmd BufLeave,FocusLost * call lib#NumberToggle(0)

	" save whenever things change
	autocmd TextChanged,TextChangedI * call lib#SaveAndRestoreVisualSelectionMarks()
augroup END
