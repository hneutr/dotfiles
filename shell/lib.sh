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

#------------------------------------------------------------------------------#
#                                    vim                                       #
#------------------------------------------------------------------------------#
function remote_nvim() {
    # avoids nesting vim sessions when opening from the terminal:
    # - if there is a vim session running, attaches to it
    # - else: starts a new vim session
    if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
        $NVIM_PATH -c "call lib#editWithoutNesting('$NVIM_LISTEN_ADDRESS')" "$@"
    else
        $NVIM_PATH "$@"
    fi
}
