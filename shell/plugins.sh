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
    function () {
        local excludes="--glob '!.git/*'"
        excludes="$excludes --glob '!Downloads/*'"
        excludes="$excludes --glob '!Library/*'"
        excludes="$excludes --glob '!Movies/*'"
        excludes="$excludes --glob '!Music/*'"
        excludes="$excludes --glob '!Pictures/*'"
        excludes="$excludes --glob '!node_modules/*'"
        excludes="$excludes --glob '!__pycache__/*'"
        export FZF_DEFAULT_COMMAND="rg --files $excludes"
    }
    alias rgl="rg -l"
fi

#------------------------------------[ fzf ]-----------------------------------#
export FZF_DEFAULT_OPTS="--reverse --multi --select-1 --exit-0"

#-----------------------------------[ bfs ]------------------------------------#
if [ -x "$(command -v bfs)" ]; then
    function () {
        local excludes="-exclude -name Library"
        excludes="$excludes -exclude -name Movies"
        excludes="$excludes -exclude -name Music"
        excludes="$excludes -exclude -name Pictures"
        excludes="$excludes -exclude -name Downloads"
        excludes="$excludes -exclude -name node_modules"
        excludes="$excludes -exclude -name research"
        excludes="$excludes -exclude -name classes"
        excludes="$excludes -exclude -name __pycache__"
        # stupid fzf wouldn't search my documents directory
        export FZF_ALT_C_COMMAND="bfs -type d -nohidden 2>/dev/null $excludes"
    }
fi
