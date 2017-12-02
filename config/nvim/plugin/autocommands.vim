augroup startup
	autocmd!

	" save whenever things change
	autocmd TextChanged,InsertLeave * call lib#SaveAndRestoreVisualSelectionMarks()

	" turn numbers on for normal buffers; turn them off for terminal buffers
	autocmd TermOpen,BufWinEnter * call lib#SetNumberDisplay()

	" when in a neovim terminal, add a buffer to the existing vim session
	" instead of nesting (credit justinmk)
	autocmd VimEnter * if !empty($NVIM_LISTEN_ADDRESS) && $NVIM_LISTEN_ADDRESS !=# v:servername
		\ |let g:r=jobstart(['nc', '-U', $NVIM_LISTEN_ADDRESS],{'rpc':v:true})
		\ |let g:f=fnameescape(expand('%:p'))
		\ |noau bwipe
		\ |call rpcrequest(g:r, "nvim_command", "edit ".g:f)
		\ |call rpcrequest(g:r, "nvim_command", "call lib#SetNumberDisplay()")
		\ |qa
		\ |endif

	" use relative numbers for focused area (maybe turn this back on with a
	" check for if number is turned on or not?)
	" autocmd BufEnter,FocusGained * call lib#NumberToggle(1)
	" autocmd BufLeave,FocusLost * call lib#NumberToggle(0)

	" enter insert mode whenever we're in a terminal
	autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert
augroup END
