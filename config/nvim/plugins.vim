let s:plug_dir = g:vim_config . ".plugged"
let s:plugin_settings_dir = g:vim_config . "startup/plugins"

call plug#begin(s:plug_dir)

"==================================[ plugins ]==================================
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fzf (easiest way to always have it point right)
Plug 'junegunn/fzf.vim'                             " fzf for vim
Plug 'altercation/vim-colors-solarized'             " colorscheme
Plug 'junegunn/goyo.vim'                            " distraction free + centered editing
Plug 'mbbill/undotree'                              " undo tree
Plug 'romainl/vim-cool'                             " it's cool
Plug 'tpope/vim-unimpaired'                         " paired options
Plug 'SirVer/ultisnips'                             " snippet engine
Plug 'junegunn/vim-easy-align'                      " align text at a separator
Plug 'tpope/vim-repeat'

"==================================[ mappings ]=================================
Plug 'hneutr/nvimux'                   " tmux replacement
Plug 'justinmk/vim-sneak'              " 2char motions
Plug 'machakann/vim-sandwich'          " deal with pairs
Plug 'tpope/vim-commentary'            " language-agnostic commenting
Plug 'vim-scripts/ReplaceWithRegister' " paste without modifying registers
Plug 'wellle/targets.vim'              " more text objects
Plug 'zirrostig/vim-schlepp'           " move things up and down

"=================================[ languages ]=================================
Plug 'plasticboy/vim-markdown'
Plug 'sheerun/vim-polyglot'
Plug 'jeetsukumaran/vim-pythonsense'

"==================================[ testing ]==================================
Plug 'neovim/nvim-lspconfig'
Plug 'chrisbra/Colorizer'
" Plug 'nvim-lua/completion-nvim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'

let g:colorizer_colornames = 0

call plug#end()

if empty(s:plug_dir)
    autocmd! VimEnter * PlugInstall
endif

" disable diagnostics support, fucking hate diagnostics
autocmd BufEnter * lua vim.diagnostic.disable()
