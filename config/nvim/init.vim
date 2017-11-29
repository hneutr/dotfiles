"===============================================================================
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
	\"plugins",
	\"mappings",
	\"autocommands",
	\"commands",
	\"abbreviations",
	\"colors",
	\]

for s:module in s:modules
	execute "source" g:vim_config . s:module . ".vim"
endfor

"============================[ local configuration ]============================
let s:local_vimrc = expand("~/.vimrc_local")
if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
endif

"===============================================================================
"==================================[ testing ]==================================
"===============================================================================
" autoformat paragraphs (see autoformat)
" set formatoptions+=a

" use the second line of the paragraph instead of the first for indent (should
" prolly be in an augroup for markdown)
" set formatoptions+=2

" lookup whichwrap
" make h/l move across beginning/end of line
" set whichwrap+=hl

" Close quickfix & help with q, Escape, or Control-C
" Also, keep default <cr> binding
augroup easy_close
	autocmd!
	autocmd FileType help,qf nnoremap <buffer> q :q<cr>
	autocmd FileType help,qf nnoremap <buffer> <Esc> :q<cr>
	autocmd FileType help,qf nnoremap <buffer> <C-c> :q<cr>
	" Undo <cr> -> : shortcut
	" autocmd FileType help,qf nnoremap <buffer> <cr> <cr>
augroup END

" nnoremap <leader>w :w<cr>
nnoremap <leader>w :echoerr "stop it you have autosave"<cr>
" cabbrev w echoerr "stop it you have autosave"
