let g:vim_config = "~/.config/nvim"
let g:plugged_path = g:vim_config . "/plugged"
let g:hne_plugin_path = g:vim_config . "startup/plugins/"

" set mapleader first so that it is available for binding.
let mapleader="\<space>"

"==========[ load startup files ]==========
runtime starup/commands.vim
runtime startup/mappings.vim
runtime startup/plugins.vim
runtime startup/functions.vim
runtime startup/autocommands.vim
runtime startup/abbreviations.vim
runtime startup/settings.vim

" add plugins to rtp so that ultisnips picks them up
set runtimepath+=g:hne_plugin_path

"==========[ load local settings ]==========
let s:local_vimrc = expand("~/.vimrc_local")
if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
endif

"==========[ testing ]==========

" open last window in split/vsplit
nnoremap <c-s-l> :vsb#<cr>
nnoremap <c-s-j> :sb#<cr>

" inoremap jf <esc>
" vnoremap jf <esc>
