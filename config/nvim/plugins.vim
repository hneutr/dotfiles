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
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'chrisbra/Colorizer'
Plug 'AndrewRadev/splitjoin.vim'

let g:colorizer_colornames = 0

call plug#end()

" if the plug dir is empty, install
if empty(s:plug_dir)
    autocmd! VimEnter * PlugInstall
endif

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

let g:lsp_diagnostics_enabled = 0         " disable diagnostics support

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    " setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
