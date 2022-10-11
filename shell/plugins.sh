#-----------------------------------[ exa ]------------------------------------#
export HAS_EXA="$(command -v exa >/dev/null 2>&1 && echo "1")"
[ "$HAS_EXA" ] && alias ls='exa --git --header --group'
[ "$HAS_EXA" ] && alias lsla='exa --long --git -a --header --group'
[ "$HAS_EXA" ] && alias tree='exa --tree --level=2 --long -a --header --git'

#------------------------------------[ fd ]------------------------------------#
export HAS_FD="$(command -v fd >/dev/null 2>&1 && echo "1")"
[ "$HAS_FD" ] && alias find='fd'

#------------------------------------[ rg ]------------------------------------#
export HAS_RG="$(command -v rg >/dev/null 2>&1 && echo "1")"
[[ "$HAS_RG" ]] && export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/*'"
[ "$HAS_RG" ] && alias rgl="rg -l"

#-----------------------------------[ bfs ]------------------------------------#
export HAS_BFS="$(command -v bfs >/dev/null 2>&1 && echo "1")"
# stupid fzf wouldn't search my documents directory
[ "$HAS_BFS" ] && export FZF_ALT_C_COMMAND="bfs -type d -nohidden 2>/dev/null -exclude -name journals"
