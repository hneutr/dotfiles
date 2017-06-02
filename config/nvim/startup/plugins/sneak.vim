let g:sneak#label        = 1 " move to next match immediately, tab through stuff
let g:sneak#absolute_dir = 1 " always go the same way.
let g:sneak#use_ic_scs   = 1 " case dependent on ignorecase+smartcase
let g:sneak#label_esc    = "<c-c>"

nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T
