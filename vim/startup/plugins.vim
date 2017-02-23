"==============================================================================
" Loading
"==============================================================================

call plug#begin('~/.vim/plugged')

if ! has('nvim')
	Plug 'noahfrederick/vim-neovim-defaults'
endif

"==========[ interface ]==========
Plug 'altercation/vim-colors-solarized'                            " colorscheme
Plug 'hunter-/tester.vim'                                          " pair test files
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do': './install --all' } " install fzf
Plug 'junegunn/fzf.vim'                                            " fzf for vim
Plug 'mileszs/ack.vim'                                             " better vimgrep
Plug 'neomake/neomake'                                             " async linting
Plug 'tpope/vim-unimpaired'                                        " paired options

"==========[ text editing ]==========
Plug 'AndrewRadev/splitjoin.vim' " join/split lines
Plug 'junegunn/vim-easy-align'   " align text at a separator
Plug 'tpope/vim-commentary'      " comment language-agnostically
Plug 'tpope/vim-speeddating'     " smarter date logic
Plug 'tpope/vim-surround'        " deal with pairs
Plug 'wellle/targets.vim'        " better text objects

"==========[ tmux ]==========
Plug 'christoomey/vim-tmux-navigator'     " move seamlessly between tmux/vim splits
Plug 'roxma/vim-tmux-clipboard'           " paste between vim windows in different tmux spots
Plug 'tmux-plugins/vim-tmux-focus-events' " focus events for tmux+vim
Plug 'wellle/tmux-complete.vim'           " autocomplete across tmux panes

"==========[ language ]==========
Plug 'Yggdroot/indentLine', { 'for' : 'python' }                " show indent lines in python
Plug 'mustache/vim-mustache-handlebars', { 'for' : 'mustache' } " syntax for mustache
Plug 'tmux-plugins/vim-tmux'                                    " syntax for .tmux.conf files
Plug 'vim-perl/vim-perl', { 'for' : 'perl' }                    " syntax for perl

"==========[ writing ]==========
Plug 'junegunn/goyo.vim' " distraction free + centered editing
Plug 'reedes/vim-pencil' " autowrap lines

"==========[ testing ]==========
Plug 'wellle/visual-split.vim' " opening specific-sized splits
" Plug 'justinmk/vim-sneak'    " looks awesome but I love 's' and :( surround.vim
" Plug 'tpope/vim-endwise'     " end some structures automatically (but
                               " conflicts with pencil)
call plug#end()

"==============================================================================
" Settings
"==============================================================================

"==========[ neomake ]==========

let g:neomake_javascript_jshint_maker = {
	\ 'args': ['--verbose'],
	\ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
	\ }
let g:neomake_javascript_enabled_markers = ['jshint']
let g:neomake_open_list = 2

"==========[ ack ]==========
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

"==========[ fzf ]==========
let g:fzf_action = { 'ctrl-l': 'vsplit', 'ctrl-j': 'split' }

"==============================================================================
" Mappings
"==============================================================================

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

nnoremap <leader>sa :Ack!<space>
nnoremap <leader>sf :FZF<cr>
nnoremap <leader>sg :Goyo<cr>
nnoremap <leader>sg :Pencil<cr>
nnoremap <leader>sn :Neomake<cr>
nnoremap <leader>stl :call g:tester.OpenPairedFile('vs')<cr>
nnoremap <leader>stj :call g:tester.OpenPairedFile()<cr>
" removed to try to use gS/gJ
" nnoremap <leader>k :SplitjoinJoin<cr>
" nnoremap <leader>j :SplitjoinSplit<cr>

