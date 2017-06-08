augroup interface
	autocmd!

	autocmd BufEnter,FocusGained * :call lib#NumberToggle(1)
	autocmd BufLeave,FocusLost * :call lib#NumberToggle(0)

	autocmd FileType markdown set conceallevel=2
	autocmd FileType markdown set concealcursor="nvc"
	autocmd FileType markdown,text set nofoldenable

	if empty(g:plugged_path)
		autocmd! VimEnter * PlugInstall
	endif
augroup END
