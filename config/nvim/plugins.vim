let s:plug_dir = g:vim_config . "plugged"
let s:plugin_settings_dir = g:vim_config . "startup/plugins"

call plug#begin(s:plug_dir)

"=================================[ interface ]=================================
Plug 'altercation/vim-colors-solarized' " colorscheme
Plug '/usr/local/opt/fzf'               " link fzf
Plug 'junegunn/fzf.vim'                 " fzf for vim
Plug 'mbbill/undotree'                  " undo tree
Plug 'tpope/vim-unimpaired'             " paired options

"===================================[ tools ]===================================
Plug 'SirVer/ultisnips'        " snippet engine
Plug 'honza/vim-snippets'      " predefined snippets
Plug 'junegunn/vim-easy-align' " align text at a separator

"==================================[ commands ]=================================
Plug 'justinmk/vim-sneak'              " 2char motions
Plug 'tpope/vim-commentary'            " language-agnostic commenting
Plug 'vim-scripts/ReplaceWithRegister' " (without overwriting)
Plug 'zirrostig/vim-schlepp'           " move things up and down

"============================[ text editing/objects ]===========================
Plug 'machakann/vim-sandwich'      " deal with pairs
Plug 'wellle/targets.vim'          " more text objects
Plug 'chaoren/vim-wordmotion'      " camelCaseMovements

"==============================[ language support ]=============================
Plug 'Glench/Vim-Jinja2-Syntax', { 'for' : 'jinja' }                     " jinja...
Plug 'autozimu/LanguageClient-neovim', { 'do' : ':UpdateRemotePlugins' } " LSP
Plug 'sheerun/vim-polyglot'                                              " many languages
Plug 'dense-analysis/ale'                                                " asynchronous lint engine

"==================================[ writing ]==================================
Plug 'junegunn/goyo.vim' " distraction free + centered editing

"==================================[ testing ]==================================
Plug 'wellle/visual-split.vim'       " opening specific-sized splits
Plug 'hneutr/nvimux'                 " tmux replacement
Plug 'junegunn/vim-online-thesaurus' " thesaurus?
" Plug 'hneutr/double-tap'             " annoying comments are annoying
" Plug 'jeetsukumaran/vim-pythonsense'
Plug 'jiangmiao/auto-pairs'

Plug 'romainl/vim-cool'

call plug#end()

" if the plug dir is empty, install
if empty(s:plug_dir)
	autocmd! VimEnter * PlugInstall
endif
