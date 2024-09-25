
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
    pandoc --pdf-engine=lualatex -s -o $output $input
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
    fzf --reverse --multi --select-1 --exit-0 --bind 'enter:become(nvim {})'
}

function vload() {
    nvim -c "source .Session.vim" -c "silent! !rm .Session.vim"
}

function open_two_vertical_terminals() {
    nvim -c "lua require('util').open_two_vertical_terminals()"
}

#------------------------------------------------------------------------------#
#                         change directory functions                           #
#------------------------------------------------------------------------------#
function chpwd {
}

# call the change directory functions at startup
chpwd
