let s:plug_dir = g:vim_config . ".plugged"
let s:plugin_settings_dir = g:vim_config . "startup/plugins"

call plug#begin(s:plug_dir)

"==================================[ plugins ]==================================
Plug 'altercation/vim-colors-solarized'             " colorscheme
Plug 'hneutr/nvimux'                                " tmux replacement
Plug 'hneutr/vim-cool'                              " it's cool
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fzf (easiest way to always have it point right)
Plug 'junegunn/fzf.vim'                             " fzf for vim
Plug 'junegunn/goyo.vim'                            " distraction free + centered editing
Plug 'tpope/vim-repeat'                             " repeat stuff
Plug 'wellle/targets.vim'                           " more objects
Plug 'L3MON4D3/LuaSnip'                             " snippets

"==================================[ mappings ]=================================
Plug 'junegunn/vim-easy-align'         " align text at a separator
Plug 'justinmk/vim-sneak'              " 2char motions
Plug 'machakann/vim-sandwich'          " deal with pairs
Plug 'tpope/vim-commentary'            " language-agnostic commenting
Plug 'tpope/vim-unimpaired'            " paired options
Plug 'vim-scripts/ReplaceWithRegister' " paste without modifying registers
Plug 'zirrostig/vim-schlepp'           " move things up and down

"=================================[ languages ]=================================
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'sheerun/vim-polyglot'

"==================================[ testing ]==================================
Plug 'neovim/nvim-lspconfig'        " try setting up, or delete?
Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()

if empty(s:plug_dir)
    autocmd! VimEnter * PlugInstall
endif
