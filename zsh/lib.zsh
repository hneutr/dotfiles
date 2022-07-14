# convert a markdown file into a pdf, swapping only the extension
# - does not require an extension on the input file
function setmd() {
    local filename="${1:r}"
    local input="${filename}.md"
    local output="${filename}.pdf"
    pandoc -s -o $output $input
}

# convert a latex file into a pdf and open it
# - does not require an extension on the input file
function settex() {
    local filename="${1:r}"
    local input="${filename}.tex"
    local output="${filename}.pdf"
    pdflatex $input && open $output
}

# fuzzy find into vim (credit to "bag-man/dotfiles/bashrc")
function fvim() {
    local IFS=$'\n'
    local files=($(fzf --reverse --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && vim "${files[@]}"
}

# refresh the virtual environment if its there
function cd_and_venv() {
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

function change_directory_functions {
  # activates an env if there is one
  cd_and_venv

  # sets a project root if there is one
  project_root_exists $PWD
}

function chpwd {
  change_directory_functions
}

# call the change directory functions when starting
change_directory_functions

function popen() {
    local filename="${1:r}.pdf"
    open $filename
}

function gmd() {
    local directory="${1}"
    mkdir ${directory}
    touch "${directory}/.gitignore"
}
