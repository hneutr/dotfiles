#------------------------------------------------------------------------------#
#                              venv_prompt_string                              #
#------------------------------------------------------------------------------#
# returns a string that displays the venv (if any)
#------------------------------------------------------------------------------#
function venv_prompt_string() {
    local venv_prompt_string=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip the path out and leave the env name
        venv_prompt_string="(${VIRTUAL_ENV##*/}) "
        echo "(${VIRTUAL_ENV##*/}) "
    else
        echo ""
    fi
}

# prints the current date in YYYYMMDD format
function today() {
    date +20%y%m%d
}

function popen() {
    # opens a pdf of the given name
    local filename="${1:r}.pdf"
    open $filename
}

function zv() {
    nvim $1 -c "Spruce"
}

source $HOME/lib/hnetxt-lua/bin/lib.sh
