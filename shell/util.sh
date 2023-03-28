export DOT_DIR=$HOME/dotfiles

function hard_source() {
    if [ -f "$1" ]; then
        chmod +x $1
        source $1
    fi
}

function path_from_args() {
    local p=""

    for part in "$@"; do 
        if [ ! -z "$p" ]; then
            p="$p/"
        fi
        p="$p$part"
    done

    echo $p
}

function dotpath() {
    echo "$DOT_DIR/$(path_from_args $@)"
}

#------------------------------------------------------------------------------#
# init_dotdir
# ------------
# - looks for a file called `$DOT_DIR/$1/init.sh`
# - if it exists:
#   - makes it executable
#   - runs it
#------------------------------------------------------------------------------#
function init_dotdir() {
    hard_source "$(dotpath $1/init.sh)"
}
