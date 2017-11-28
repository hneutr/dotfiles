" hotkeys for pane opening
" let g:fzf_action = { 'ctrl-l': 'vsplit', 'ctrl-j': 'split' }

" Append --no-height to fix weird issue with neovim terminal buffers
let $FZF_DEFAULT_OPTS .= ' --no-height'
