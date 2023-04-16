let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/dotfiles/lex/constants
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +78 term://~/dotfiles/lex/constants//73256:/bin/zsh
badd +78 term://~/dotfiles/lex/constants//73257:/bin/zsh
badd +4 ~/dotfiles/lex/yaml/flags.yaml
badd +4 ~/dotfiles/lex/yaml/fuzzy_actions.yaml
badd +1 ~/dotfiles/lex/yaml/mirror_defaults.yaml
badd +5 ~/dotfiles/lex/yaml/init.yaml
badd +0 term://~/dotfiles/lex/constants//74872:/bin/zsh
badd +22 ~/dotfiles/nvim/lua/util/path.lua
badd +39 term://~/dotfiles/lex/constants//75928:/bin/zsh
badd +0 ~/dotfiles/nvim/lua/lex/constants.lua
badd +57 term://~/dotfiles/lex/constants//76216:/bin/zsh
badd +0 ~/dotfiles/nvim/lua/lex/link.lua
argglobal
%argdel
edit ~/dotfiles/nvim/lua/util/path.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 38 + 40) / 80)
exe 'vert 1resize ' . ((&columns * 118 + 119) / 238)
exe '2resize ' . ((&lines * 39 + 40) / 80)
exe 'vert 2resize ' . ((&columns * 118 + 119) / 238)
exe '3resize ' . ((&lines * 38 + 40) / 80)
exe 'vert 3resize ' . ((&columns * 119 + 119) / 238)
exe '4resize ' . ((&lines * 39 + 40) / 80)
exe 'vert 4resize ' . ((&columns * 119 + 119) / 238)
argglobal
balt term://~/dotfiles/lex/constants//73256:/bin/zsh
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=1
setlocal nofen
let s:l = 22 - ((10 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 22
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/nvim/lua/lex/link.lua", ":p")) | buffer ~/dotfiles/nvim/lua/lex/link.lua | else | edit ~/dotfiles/nvim/lua/lex/link.lua | endif
if &buftype ==# 'terminal'
  silent file ~/dotfiles/nvim/lua/lex/link.lua
endif
balt term://~/dotfiles/lex/constants//76216:/bin/zsh
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=1
setlocal nofen
let s:l = 12 - ((3 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 12
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/lex/yaml/init.yaml", ":p")) | buffer ~/dotfiles/lex/yaml/init.yaml | else | edit ~/dotfiles/lex/yaml/init.yaml | endif
if &buftype ==# 'terminal'
  silent file ~/dotfiles/lex/yaml/init.yaml
endif
balt term://~/dotfiles/lex/constants//73257:/bin/zsh
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=1
setlocal nofen
let s:l = 5 - ((4 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 5
normal! 010|
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/nvim/lua/lex/constants.lua", ":p")) | buffer ~/dotfiles/nvim/lua/lex/constants.lua | else | edit ~/dotfiles/nvim/lua/lex/constants.lua | endif
if &buftype ==# 'terminal'
  silent file ~/dotfiles/nvim/lua/lex/constants.lua
endif
balt term://~/dotfiles/lex/constants//75928:/bin/zsh
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=1
setlocal nofen
let s:l = 6 - ((5 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 6
normal! 0
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 38 + 40) / 80)
exe 'vert 1resize ' . ((&columns * 118 + 119) / 238)
exe '2resize ' . ((&lines * 39 + 40) / 80)
exe 'vert 2resize ' . ((&columns * 118 + 119) / 238)
exe '3resize ' . ((&lines * 38 + 40) / 80)
exe 'vert 3resize ' . ((&columns * 119 + 119) / 238)
exe '4resize ' . ((&lines * 39 + 40) / 80)
exe 'vert 4resize ' . ((&columns * 119 + 119) / 238)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
