# find the project root if it exists and set up aliases
# if not project root exists, clear aliases
function project_root_exists() {
    local directory=$1
    local project_file="$directory/.project"

    if [ -f $project_file ]; then
        alias mv=hnetxt_mv
        alias rm=hnetxt_rm
        export PROJECT_ROOT=$directory
    else
        local parent=$(dirname $directory)

        if [ $parent = '/' ]; then
            unset PROJECT_ROOT

            # unset the aliases
            if [ ${+aliases[mv]} -eq 1 ]; then
                unalias mv
            fi

            if [ ${+aliases[rm]} -eq 1 ]; then
                unalias rm
            fi

            if [ ${+aliases[new]} -eq 1 ]; then
                unalias new
            fi

            alias vim=nvim
        else
            # call recursively if we're not bottomed out yet
            project_root_exists $parent
        fi
    fi
}

function hnetxt() {
    luajit $HOME/lib/hnetxt-lua/src/htc/init.lua $@
}

function hnetxt_test() {
    local START_DIR=$PWD
    cd $HOME/lib/hnetxt-lua
    luarocks --lua-version 5.1 make > /dev/null
    cd $START_DIR
    hnetxt $@
}

function hnetxt_mv() {
    hnetxt move $@
}

function hnetxt_rm() {
    hnetxt remove $@
}

function journal() {
    nvim $(hnetxt journal $@) -c "lua require('zen-mode').toggle()"
}

function new() {
    nvim $(hnetxt new $@)
}

function track() {
    nvim $(hnetxt track $@)
}

function aim() {
    nvim $(hnetxt aim $@)
}

function wr() {
    nvim $1 -c "lua require('htn.project.mirror').open('outlines')" +bnext -c "lua require('zen-mode').toggle()"
}

function quote() {
    nvim $(hnetxt quote $@) +"lua require('htn.ui').quote()"
}

alias tags="hnetxt tags"
alias project="hnetxt project"

alias ht="hnetxt"
alias htt="hnetxt_test"
