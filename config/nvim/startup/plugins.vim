"==============================================================================
" Loading
"==============================================================================

call plug#begin(g:plugged_path)

"==========[ interface ]==========
Plug 'altercation/vim-colors-solarized'                            " colorscheme
Plug 'hunter-/tester.vim'                                          " pair test files
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do': './install --all' } " install fzf
Plug 'junegunn/fzf.vim'                                            " fzf for vim
Plug 'tpope/vim-unimpaired'                                        " paired options
Plug 'w0rp/ale'                                                    " asynchronous lint engine

"==========[ text editing ]==========
Plug 'AndrewRadev/splitjoin.vim' " join/split lines
Plug 'junegunn/vim-easy-align'   " align text at a separator
Plug 'justinmk/vim-sneak'        " 2char motions
Plug 'tpope/vim-commentary'      " comment language-agnostically
Plug 'tpope/vim-speeddating'     " smarter date logic
Plug 'tpope/vim-surround'        " deal with pairs
Plug 'wellle/targets.vim'        " better text objects
Plug 'zirrostig/vim-schlepp'     " move lines around
Plug 'SirVer/ultisnips'          " snippet engine
Plug 'honza/vim-snippets'        " predefined snippets

"==========[ tmux ]==========
Plug 'christoomey/vim-tmux-navigator'     " move seamlessly between tmux/vim splits
Plug 'roxma/vim-tmux-clipboard'           " paste between vim windows in different tmux spots
Plug 'tmux-plugins/vim-tmux-focus-events' " focus events for tmux+vim
Plug 'wellle/tmux-complete.vim'           " autocomplete across tmux panes

"==========[ language/syntax ]==========
Plug 'mustache/vim-mustache-handlebars', { 'for' : 'mustache' } " mustache
Plug 'tmux-plugins/vim-tmux', { 'for' : 'tmux' }                " tmux
Plug 'tpope/vim-markdown', { 'for' : 'markdown' }               " markdown; supports conceal
Plug 'vim-perl/vim-perl', { 'for' : 'perl' }                    " perl

"==========[ writing ]==========
Plug 'junegunn/goyo.vim', { 'for' : [ 'markdown', 'html', 'text' ], } " distraction free + centered editing
Plug 'reedes/vim-pencil', { 'for' : [ 'markdown', 'html', 'text' ], } " autowrap lines

"==========[ testing ]==========
Plug 'wellle/visual-split.vim'     " opening specific-sized splits
Plug 'reedes/vim-textobj-sentence' " improved sentence object
Plug 'shougo/denite.nvim'          " meta-whackness 10
Plug 'Glench/Vim-Jinja2-Syntax'
" Plug 'sts10/vim-zipper'			   " better folding?

call plug#end()

"==============================================================================
" Settings
"==============================================================================

"==========[ fzf ]==========
let g:fzf_action = { 'ctrl-l': 'vsplit', 'ctrl-j': 'split' }

"==========[ pencil ]==========
let g:pencil#textwidth = 80

"==========[ surround ]==========
let g:surround_indent = 1

"==============================================================================
" Mappings
"==============================================================================

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

nnoremap <leader>sd<space> :Denite 
nnoremap <leader>sf :FZF<cr>
nnoremap <leader>sg :Goyo<cr>
nnoremap <leader>sn :Neomake<cr>
nnoremap <leader>sp :PencilToggle<cr>
nnoremap <leader>stj :call g:tester.OpenPairedFile()<cr>
nnoremap <leader>stl :call g:tester.OpenPairedFile('vs')<cr>
nnoremap <leader>su :UltiSnipsEdit<cr>

"==============================================================================
" Plugin Setting files
"==============================================================================
runtime startup/plugins/denite.vim
runtime startup/plugins/schlepp.vim
runtime startup/plugins/sneak.vim
runtime startup/plugins/ultisnips.vim