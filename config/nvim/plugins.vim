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
Plug 'AndrewRadev/splitjoin.vim'   " join/split lines
Plug 'machakann/vim-sandwich'      " deal with pairs
Plug 'tpope/vim-speeddating'       " smarter date logic
Plug 'wellle/targets.vim'          " more text objects
Plug 'reedes/vim-textobj-sentence' " improved sentence object

"====================================[ tmux ]===================================
Plug 'christoomey/vim-tmux-navigator'     " move seamlessly between tmux/vim splits
Plug 'christoomey/vim-tmux-runner'        " rerun tests
Plug 'roxma/vim-tmux-clipboard'           " paste between vim windows across tmux
Plug 'tmux-plugins/vim-tmux-focus-events' " focus events for tmux+vim
Plug 'wellle/tmux-complete.vim'           " autocomplete across tmux panes

"==============================[ language support ]=============================
Plug 'Glench/Vim-Jinja2-Syntax', { 'for' : 'jinja' }                     " jinja...
Plug 'autozimu/LanguageClient-neovim', { 'do' : ':UpdateRemotePlugins' } " LSP
Plug 'sheerun/vim-polyglot'                                              " many languages
Plug 'w0rp/ale'                                                          " asynchronous lint engine

"==================================[ writing ]==================================
Plug 'junegunn/goyo.vim' " distraction free + centered editing

"==================================[ testing ]==================================
Plug 'wellle/visual-split.vim' " opening specific-sized splits
Plug 'hkupty/nvimux'           " tmux replacement

call plug#end()

" if the plug dir is empty, install
if empty(s:plug_dir)
	autocmd! VimEnter * PlugInstall
endif

" source plugin settings that must execute before the plugins load
for plugin_setting in split(globpath(s:plugin_settings_dir, "*.vim"), "\n")
	try
		execute "source" plugin_setting
	catch
	endtry
endfor
