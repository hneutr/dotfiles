"==============================================================================
" General
"==============================================================================

runtime startup/settings.vim
runtime startup/plugins.vim
runtime startup/functions.vim
runtime startup/autocommands.vim
runtime startup/mappings.vim

set background=dark
colorscheme solarized

"==============================================================================
" Mappings
"==============================================================================

"==============================================================================
" Abbrievations
"==============================================================================
"==========[ date/time ]==========
iabbrev _sdate <c-r>=strftime("%Y/%m/%d")<cr>
iabbrev _date <c-r>=strftime("%m/%d/%y")<cr>

"==============================================================================
" Plugins and Misc
"==============================================================================
"==========[ local vimrc ]==========
let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
	source $LOCALFILE
endif

"==========[ tester.vim ]==========
nnoremap <leader>t :call g:tester.OpenPairedFile()<cr>
nnoremap <leader>T :call g:tester.OpenPairedFile('vs')<cr>

"==========[ neomake ]==========
let g:neomake_javascript_jshint_maker = {
	\ 'args': ['--verbose'],
	\ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
	\ }
let g:neomake_javascript_enabled_markers = ['jshint']
let g:neomake_open_list = 2

nnoremap <leader>n :Neomake<cr>

"==========[ Splitjoin ]==========
nnoremap <leader>k :SplitjoinJoin<cr>
nnoremap <leader>j :SplitjoinSplit<cr>

"==========[ ack ]==========
cnoreabbrev ag Ack!
nnoremap <leader>a :Ack!<space>

if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

"==========[ fzf ]==========
nnoremap <leader>f :FZF<cr>

let g:fzf_action = {
	\'ctrl-b': 'vsplit',
	\'ctrl-v': 'split'}

"==========[ easy align ]==========
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

"==============================================================================
" Testing
"==============================================================================

" quickly edit macros
nnoremap <leader>m :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" more intuitive completion mappings
inoremap <c-j> <c-n>
inoremap <c-k> <c-p>
inoremap <c-u> <c-x><c-u>
inoremap <c-f> <c-x><c-f>
inoremap <c-]> <c-x><c-]>
" inoremap <c-l> <c-x><c-l>

" more intuitive untab/retab
inoremap <c-l> <c-t>
inoremap <c-h> <c-d>

