source $DOTFILES/hnetxt/lib.sh

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
