#------------------------------------------------------------------------------#
#                                    misc                                      #
#------------------------------------------------------------------------------#
function gmd() {
    # creates a .gitignore file
    local directory="${1}"
    mkdir ${directory}
    touch "${directory}/.gitignore"
}

function today() {
    # prints the current date in YYYYMMDD format
    date +20%y%m%d
}

function setmd() {
    # convert: markdown → pdf
    # - input: {name of markdown file} (extension optional)
    # - output: {name of markdown file}.pdf
    local filename="${1:r}"
    local input="${filename}.md"
    local output="${filename}.pdf"
    pandoc -s -o $output $input
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

function popen() {
    # opens a pdf of the given name
    local filename="${1:r}.pdf"
    open $filename
}

#------------------------------------------------------------------------------#
#                                    vim                                       #
#------------------------------------------------------------------------------#
function fvim() {
    # fuzzy find into vim (credit to "bag-man/dotfiles/bashrc")
    local IFS=$'\n'
    local files=($(fzf --reverse --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && vim "${files[@]}"
}

function remote_nvim() {
    # avoids nesting vim sessions when opening from the terminal:
    # - if there is a vim session running, attaches to it
    # - else: starts a new vim session
    if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
        /usr/local/bin/nvim -c "call lib#editWithoutNesting('$NVIM_LISTEN_ADDRESS')" "$@"
    else
        /usr/local/bin/nvim "$@"
    fi
}

#------------------------------------------------------------------------------#
#                       handling virtual environments                          #
#------------------------------------------------------------------------------#
function cd_and_venv() {
    # refresh the virtual environment if its there
    if [ -f $PWD/env/bin/activate ]; then
        type deactivate > /dev/null && deactivate
        source $PWD/env/bin/activate
    fi
}

function deactivate_env() {
    if [ -f $PWD/env/bin/activate ]; then
        type deactivate > /dev/null && deactivate
    fi
}

#------------------------------------------------------------------------------#
#                                 lex stuff                                    #
#------------------------------------------------------------------------------#
# finds the project root if it exists and aliases mv to pmv;
# otherwise, unaliases mv
function project_root_exists() {
    local directory=$1
    local project_file="$directory/.project"

    if [ -f $project_file ]; then
        alias mv=pmv
        export PROJECT_ROOT=$directory
    else
        local parent=$(dirname $directory)

        if [ $parent = '/' ]; then
        unset PROJECT_ROOT

        # unset the alias
        if [ ${+aliases[mv]} -eq 1 ]; then
            unalias mv
        fi
        else
            # call recursively if we're not bottomed out yet
            project_root_exists $parent
        fi
    fi
}

function goals() {
    nvim -c "call lib#Goals()"
}

#------------------------------------------------------------------------------#
#                         change directory functions                           #
#------------------------------------------------------------------------------#
function chpwd {
  # activates an env if there is one
  cd_and_venv

  # sets a project root if there is one
  project_root_exists $PWD
}
