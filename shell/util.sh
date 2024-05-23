function hard_source() {
    if [ -f "$1" ]; then
        source $1
    fi
}

function OS() {
    if [ "$(uname)" = "Darwin" ]; then
        echo "macos"
    fi
}

function setup_dotdir() {
    hard_source $1/setup.sh
    if [ -d "$1/extra" ]; then
	      echo $(which fd)
        for extra in "$(fd 'setup.sh' $1/extra)"; do
            echo $extra
            setup_dotdir "$(dirname $extra)"
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
