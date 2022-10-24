#------------------------------------------------------------------------------#
#                                    misc                                      #
#------------------------------------------------------------------------------#
function gmd() {
    # creates a .gitignore file
    local directory="${1}"
    mkdir ${directory}
    touch "${directory}/.gitignore"
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

#------------------------------------------------------------------------------#
#                                    vim                                       #
#------------------------------------------------------------------------------#
function fvim() {
    # fuzzy find into vim
    local IFS=$'\n'
    local files=($(fzf --reverse --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && vim "${files[@]}"
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
        alias mv=nvim_mv
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
    nvim -c "lua require'util'.open_path(require'lex.goals'.path())"
}

function _journal() {
    nvim -c "lua require'util'.open_path(require'lex.journal'.path({ $1 }))" +GoyoToggle -c "1"
}

function nvim_mv() {
    nvim --headless -c "lua require'lex.move'.move('$1', '$2')" +q
}

function nvim_mv_debug() {
    nvim -c "lua require'lex.move'.move('$1', '$2')"
}

function wr() {
    nvim $1 -c "lua require'lex.mirror'.open('outlines')" +bnext +GoyoToggle
}

function vload() {
    nvim -c "source .Session.vim" -c "silent! !rm .Session.vim"
}

function start_project() {
    mkdir meta && touch meta/@.md
    mkdir story
    mkdir context
    mkdir text

    git init > /dev/null

    echo ".DS_Store\n.project" > .gitignore

    local contents=""
    if [[ $# -gt 0 ]]; then
        contents='"name": "'$1'"'
    fi

    echo "{"$contents"}" > .project
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

# call the change directory functions at startup
chpwd
