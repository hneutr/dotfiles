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

function OS() {
    if [ "$(uname)" = "Darwin" ]; then
        echo "macos"
    fi
}

function setup_dotdir() {
    hard_source $1/setup.sh
    if [ -d "$1/extra" ]; then
        for extra in "$(fd 'setup.sh' $1/extra)"; do
            setup_dir "$(dirname $extra)"
        done
    fi
}

function rc_init_dir() {
    hard_source $1/rc.sh
    if [ -d "$1/extra" ]; then
        for extra in "$(fd 'rc.sh' $1/extra)"; do
            if [ ! -z $extra ]; then
                rc_init_dir "$(dirname $extra)"
            fi
        done
    fi
}
