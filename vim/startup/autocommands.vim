augroup interface
	autocmd!

	autocmd! BufEnter,FocusGained * :call NumberToggle(1)
	autocmd! BufLeave,FocusLost * :call NumberToggle(0)

	if empty('~/.vim/plugged')
		autocmd! VimEnter * PlugInstall
	endif
augroup END
