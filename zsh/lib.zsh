#------------------------------------------------------------------------------#
#                                    misc                                      #
#------------------------------------------------------------------------------#
function gmd() {
    # creates a .gitignore file
    local directory="${1}"
    mkdir ${directory}
    touch "${directory}/.gitignore"
}

function settex() {
    # convert: latex → pdf and open the pdf
    # - input: {name of latex file} (extention optional)
    # - output: {name of latex file}.pdf && open
    local filename="${1:r}"
    local input="${filename}.tex"
    local output="${filename}.pdf"
    pdflatex $input && open $output
}

#------------------------------------------------------------------------------#
#                                    vim                                       #
#------------------------------------------------------------------------------#
function fuzzyvim(){
    setopt localoptions pipefail no_aliases 2> /dev/null

    local file=$(eval "${FZF_DEFAULT_COMMAND}" | $(__fzfcmd) -m "$@" | while read item; do
        echo -n "${(q)item}"
    done)

    local ret=$?

    if [[ -n $file ]]; then
        zle push-line
        BUFFER="$EDITOR $file"
        zle accept-line
    fi

    zle reset-prompt
    return $ret
}

zle -N fuzzyvim

#------------------------------------------------------------------------------#
#                         change directory functions                           #
#------------------------------------------------------------------------------#
function chpwd {
}

# call the change directory functions at startup
chpwd
