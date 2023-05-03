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
        type deactivate > /dev/null && source deactivate
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
        alias mv=hnetxt_mv
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

function hnetxt() {
    lua $HOME/lib/hnetxt-cli/src/hnetxt-cli/init.lua $@
}

function hnetxt_test() {
    local START_DIR=$PWD
    cd $HOME/lib/hnetxt-cli
    luarocks make > /dev/null
    cd $START_DIR
    hnetxt $@
}

function hnetxt_mv() {
    lua $HOME/lib/hnetxt-cli/src/hnetxt-cli/init.lua move $1 $2
}

function goals() {
    nvim $(lua $HOME/lib/hnetxt-cli/src/hnetxt-cli/init.lua goals)
}

function journal() {
    nvim $(lua $HOME/lib/hnetxt-cli/src/hnetxt-cli/init.lua journal $@) +GoyoToggle -c "1" 
}

function wr() {
    nvim $1 -c "lua require('hnetxt-nvim.project.mirror').open('outlines')" +bnext +GoyoToggle
}

function vload() {
    nvim -c "source .Session.vim" -c "silent! !rm .Session.vim"
}

#------------------------------------------------------------------------------#
#                         change directory functions                           #
#------------------------------------------------------------------------------#
function chpwd {
  # activates an env if there is one
  # cd_and_venv

  # sets a project root if there is one
  project_root_exists $PWD
}

# call the change directory functions at startup
chpwd
