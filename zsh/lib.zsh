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
