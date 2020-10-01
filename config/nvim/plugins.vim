let s:plug_dir = g:vim_config . "plugged"
let s:plugin_settings_dir = g:vim_config . "startup/plugins"

call plug#begin(s:plug_dir)

"=================================[ interface ]=================================
Plug 'altercation/vim-colors-solarized' " colorscheme
Plug '/usr/local/opt/fzf'               " link fzf
Plug 'junegunn/fzf.vim'                 " fzf for vim
Plug 'mbbill/undotree'                  " undo tree
Plug 'tpope/vim-unimpaired'             " paired options
Plug 'junegunn/goyo.vim'                " distraction free + centered editing

"===================================[ tools ]===================================
Plug 'SirVer/ultisnips'        " snippet engine
Plug 'honza/vim-snippets'      " predefined snippets
Plug 'junegunn/vim-easy-align' " align text at a separator
Plug 'tpope/vim-repeat'

"============================[ text editing/objects ]===========================
Plug 'hneutr/nvimux'                   " tmux replacement
Plug 'justinmk/vim-sneak'              " 2char motions
Plug 'machakann/vim-sandwich'          " deal with pairs
Plug 'tpope/vim-commentary'            " language-agnostic commenting
Plug 'vim-scripts/ReplaceWithRegister' " paste without modifying registers
Plug 'wellle/targets.vim'              " more text objects
Plug 'zirrostig/vim-schlepp'           " move things up and down

"==============================[ language support ]=============================
" Plug 'Glench/Vim-Jinja2-Syntax', { 'for' : 'jinja' } " jinja...
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"==================================[ testing ]==================================
Plug 'junegunn/vim-online-thesaurus' " thesaurus?

Plug 'romainl/vim-cool'
Plug 'plasticboy/vim-markdown'
Plug 'sheerun/vim-polyglot'
" Plug 'jeetsukumaran/vim-pythonsense'
" Plug 'chaoren/vim-wordmotion'      " camelCaseMovements

let g:polyglot_disabled = ['markdown']

call plug#end()

" if the plug dir is empty, install
if empty(s:plug_dir)
	autocmd! VimEnter * PlugInstall
endif
