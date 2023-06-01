# find the project root if it exists and set up aliases
# if not project root exists, clear aliases
function project_root_exists() {
    local directory=$1
    local project_file="$directory/.project"

    if [ -f $project_file ]; then
        alias mv=hnetxt_mv
        alias rm=hnetxt_rm
        alias touch=hnetxt_touch
        alias vim=hnetxt_vim
        alias ns=hnetxt_ls
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

            if [ ${+aliases[touch]} -eq 1 ]; then
                unalias touch
            fi

            if [ ${+aliases[ns]} -eq 1 ]; then
                unalias ns
            fi

            alias vim=nvim
        else
            # call recursively if we're not bottomed out yet
            project_root_exists $parent
        fi
    fi
}

function hnetxt() {
    lua $HOME/lib/hnetxt-cli/src/htc/init.lua $@
}

function hnetxt_test() {
    local START_DIR=$PWD
    cd $HOME/lib/hnetxt-cli
    luarocks make > /dev/null
    cd $START_DIR
    hnetxt $@
}

function hnetxt_mv() {
    hnetxt move $@
}

function hnetxt_rm() {
    hnetxt remove $@
}

function hnetxt_touch() {
    hnetxt notes touch $@
}

function hnetxt_notes() {
    hnetxt notes $@
}

function hnetxt_vim() {
    nvim $(hnetxt notes touch $@)
}

function hnetxt_ls() {
    hnetxt notes list $@
}

function hnetxt_meta() {
    hnetxt notes meta $@
}

function goals() {
    nvim $(hnetxt goals $@)
}

function journal() {
    nvim $(hnetxt journal $@) +GoyoToggle -c "1" 
}

function wr() {
    nvim $1 -c "lua require('htn.project.mirror').open('outlines')" +bnext +GoyoToggle
}

alias meta=hnetxt_meta
alias notes=hnetxt_notes
