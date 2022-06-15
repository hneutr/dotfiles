"==============================================================================
"======================[ structure and guiding principles ]=====================
"===============================================================================
" 1. Be consistent
" 2. Readability is valuable
" 3. Functional value > Aesthetic value
" 4. Comment regularly
" 5. Comment only when useful
" 6. Build for yourself
" 7. Modularity is good when it helps
"
" Style:
" - comments on the line above their referant

"===================================[ config ]==================================
let g:vim_config = $HOME . "/.config/nvim/"

let s:modules = [
	\"settings",
	\"mappings",
	\"plugins",
	\]

for s:module in s:modules
	execute "source" g:vim_config . s:module . ".vim"
endfor

"============================[ local configuration ]============================
let s:local_vimrc = expand("~/.vimrc_local")
if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
endif

call lib#setProjectRoot()

"===============================================================================
"==================================[ testing ]==================================
"===============================================================================
let g:python3_host_prog = '/Users/hne/.pyenv/shims/python3'

" Close quickfix & help with q, Escape, or Control-C
" Also, keep default <cr> binding
augroup easy_close
	autocmd!
	autocmd FileType help,qf nnoremap <buffer> q :q<cr>
	autocmd FileType help,qf nnoremap <buffer> <Esc> :q<cr>
	autocmd FileType help,qf nnoremap <buffer> <C-c> :q<cr>
augroup END

" testing how to avoid stupid paste mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

" the fuck, why is my cwd not being set
execute "chdir $PWD"

" open file at last point
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

set updatetime=300

" lua << EOF
" require('settings')
" EOF
