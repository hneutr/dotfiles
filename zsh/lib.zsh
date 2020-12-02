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

# set the change directory function to cd_and_venv
function chpwd {
  cd_and_venv
}

# call the change directory function
cd_and_venv

function popen() {
    local filename="${1:r}.pdf"
    open $filename
}

function gmd() {
    local directory="${1}"
    mkdir ${directory}
    touch "${directory}/.gitignore"
}
