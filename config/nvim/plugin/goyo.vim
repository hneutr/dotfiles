call lib#AddPluginMapping('g', ':Goyo<cr>')

" set a variable to later restore the <leader>q command from
let g:previous_leader_q_command_rhs = ''

function! s:goyo_enter()
    setlocal noshowmode
    setlocal noshowcmd
    setlocal scrolloff=999
    setlocal sidescroll=0
    setlocal spell

    " save the previously mapped <leader>q command
    let g:previous_leader_q_command = ''
    redir => previous_leader_q_command
    silent verbose nmap <leader>q
    redir end

    let g:previous_leader_q_command_rhs = split(previous_leader_q_command)[3]

    nnoremap <leader>q :Goyo<cr>:q<cr>
endfunction

function! s:goyo_leave()
    setlocal showmode
    setlocal showcmd
    setlocal scrolloff=10
    setlocal nospell

    " restore the previously mapped <leader>q command
    execute "nnoremap <leader>q " . g:previous_leader_q_command_rhs
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
