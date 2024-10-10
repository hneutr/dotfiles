function OS() {
    if [ "$(uname)" = "Darwin" ]; then
        echo "macos"
    fi
}

function setup_dotdir() {
    source $1/setup.sh 2> /dev/null
    local EXTRA_DIR=$1/extra
    if [ -d $EXTRA_DIR ]; then
        for extra in $EXTRA_DIR/*/rc.sh; do
            setup_dotdir "$(dirname $extra)"
        done
    fi
}

function rc_init_dir() {
    source $1/rc.sh 2> /dev/null
    local EXTRA_DIR=$1/extra
    if [ -d $EXTRA_DIR ]; then
        for extra in $EXTRA_DIR/*/rc.sh; do
            rc_init_dir "$(dirname $extra)"
        done
    fi
}
