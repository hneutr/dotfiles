function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  setlocal noshowmode
  setlocal noshowcmd
  setlocal scrolloff=999
  setlocal sidescroll=0
  setlocal spell
  set wrap
  set linebreak
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  setlocal showmode
  setlocal showcmd
  setlocal scrolloff=10
  setlocal nospell
  set nowrap
  set nolinebreak
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
