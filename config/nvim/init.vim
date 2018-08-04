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

"===============================================================================
"==================================[ testing ]==================================
"===============================================================================
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

" testing python....... to get the cwd of a terminal buffer...
" function! TestingCWD()
" " from neovim import attach
" python3 << EOF
" import os
" os.environ['HNENE'] = os.getcwd()
" EOF
" " nvim = attach('socket', path=os.environ['NVIM_LISTEN_ADDRESS'])
" " nvim.command("let actual_cwd = %s" % os.getcwd())
" endfunction

" function! Test()
"     if exists(g:__autocd_cwd)
"         execute "lcd" fnameescape(g:__autocd_cwd)
"         unlet g:__autocd_cwd
"     endif
" endfunction

" autocmd User * Test()

" testing mapping of <c-t>
" nnoremap <c-t> :terminal<cr>

" thanks to vim-scripts/EnhancedJumps for jump parsing code
function! s:GetJumps()
    " grab jumplist
    redir => l:raw_jumps
    silent! execute "jumps"
    redir END

    " The first line contains the header.
    let l:jumps = split(l:raw_jumps, "\n")[1:] 

    let l:parsed = []
    for l:line in l:jumps
        let l:parseResult = matchlist(l:line, '^>\?\s*\(\d\+\)\s\+\(\d\+\)\s\+\(\d\+\)\s\+\(.*\)$')

        let l:count = get(l:parseResult, 1, 0)
        let l:text = get(l:parseResult, 4, '')

        call add(l:parsed, l:text)
    endfor

    " jumplist is reversed
    let l:parsed = reverse(l:parsed)

    return l:parsed
endfunction

function! GoToTerminalOrMakeOne()
    let l:buffers = copy(getbufinfo())
    let l:term_buffers = filter(l:buffers, 'v:val.name =~ "^term://*"')
    let l:term_buffers_dicts = map(l:term_buffers, '{v:val.name : v:val.bufnr}')

    " if there are terminal buffers, try to find one in the jump list
    if len(l:term_buffers_dicts)
        let l:jumps = s:GetJumps()

        " loop over the jumps list to go to the most recent terminal buffer
        for l:jump in l:jumps
            " loop over the buffer_dicts to get buffer number
            for l:buffer_dict in l:term_buffers_dicts
                let l:buffer_number = get(l:buffer_dict, l:jump, 0)

                " if we found a buffer, then go to it
                if l:buffer_number
                    execute "buf" l:buffer_number
                    return
                endif
            endfor
        endfor
    endif

    " if there are no terminal buffers, or if there were none in the jumplist,
    " just open a new terminal
    terminal
    return
endfunction

" I think what I really want, is to store a variable somewhere that keeps
" track of something like a terminal/file pair, and which I switch between
function! LeaveTerminalOrClose()
    let l:buffers = copy(getbufinfo())
    let l:nonterm_buffers = filter(l:buffers, 'v:val.name !~ "^term://*"')
    let l:nonterm_buffers_dicts = map(l:nonterm_buffers, '{v:val.name : v:val.bufnr}')

    " if there are non-terminal buffers, try to find one in the jump list
    if len(l:nonterm_buffers_dicts)
        let l:jumps = s:GetJumps()

        " loop over the jumps list to go to the most recent nonterminal buffer
        for l:jump in l:jumps
            let l:jump = expand(l:jump)
            " loop over the buffer_dicts to get buffer number
            for l:buffer_dict in l:nonterm_buffers_dicts
                let l:buffer_number = get(l:buffer_dict, l:jump, 0)

                " if we found a buffer, then go to it
                if l:buffer_number
                    execute "buf" l:buffer_number
                    return
                endif
            endfor
        endfor
    endif

    " if there are no nonterminal buffers, or if there were none in the jumplist,
    " close the terminal pane
    execute "close"
    return
endfunction


" function! ResizeForHelp() abort
"     if winheight('%') < ( winwidth('%') / 2 )
"         execute 'wincmd L'
"     endif
" endfunction

" autocmd FileType help if &buftype == 'help' | call ResizeForHelp() | endif

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
