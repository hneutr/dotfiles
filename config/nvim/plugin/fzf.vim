call lib#AddPluginMapping('f', ':FZF<cr>')

" Append --no-height to fix weird issue with neovim terminal buffers
let $FZF_DEFAULT_OPTS .= ' --no-height'

inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

augroup user:autocmd:fzf
	autocmd!

	" turn off the status bar when fzf is running
	autocmd FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2

	" hotkeys for pane opening (consistent with nvimux)
	au TermOpen term://*FZF tnoremap <silent> <buffer> <nowait> <c-j> <c-x>
	au TermOpen term://*FZF tnoremap <silent> <buffer> <nowait> <c-l> <c-v>
augroup END
