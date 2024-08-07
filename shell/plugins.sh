#-----------------------------------[ exa ]------------------------------------#
if [ -x "$(command -v eza)" ]; then
    alias ls='eza --git --header --group'
    alias lsla='eza --long --git -a --header --group'
    alias tree='eza --tree --level=2 --long -a --header --git'
fi

#------------------------------------[ fd ]------------------------------------#
if [ -x "$(command -v fd)" ]; then
    alias find='fd'
fi

#------------------------------------[ rg ]------------------------------------#
if [ -x "$(command -v fd)" ]; then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/*' --glob '!Library/*'"
    alias rgl="rg -l"
fi

#-----------------------------------[ bfs ]------------------------------------#
if [ -x "$(command -v bfs)" ]; then
    # stupid fzf wouldn't search my documents directory
    export FZF_ALT_C_COMMAND="bfs -type d -nohidden 2>/dev/null -exclude -name Library"
fi
