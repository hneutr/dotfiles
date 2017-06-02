augroup interface
	autocmd!

	autocmd! BufEnter,FocusGained * :call lib#NumberToggle(1)
	autocmd! BufLeave,FocusLost * :call lib#NumberToggle(0)

	if empty(g:plugged_path)
		autocmd! VimEnter * PlugInstall
	endif
augroup END
