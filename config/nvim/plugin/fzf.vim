call lib#AddPluginMapping('f', ':FZF<cr>')

" Append --no-height to fix weird issue with neovim terminal buffers
let $FZF_DEFAULT_OPTS .= ' --no-height'

inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

function! Testing()
  echo "hello"
  let @" = getline('.')
endfunction

augroup user:autocmd:fzf
	autocmd!

	" turn off the status bar when fzf is running
	autocmd FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2

	" hotkeys for pane opening (consistent with nvimux)
	au TermOpen term://*FZF tnoremap <silent> <buffer> <nowait> <c-j> <c-x>
	au TermOpen term://*FZF tnoremap <silent> <buffer> <nowait> <c-l> <c-v>
augroup END

let g:fzf_layout = { 'window': 'call FloatingFZF()' }
" let g:fzf_action = { 
"       \ 'ctrl-l': 'vsplit',
"       \ 'ctrl-j': 'split' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(10)
  let width = float2nr(80)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = float2nr((&lines - height) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction
