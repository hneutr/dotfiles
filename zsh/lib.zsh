# convert a markdown file into a pdf, swapping only the extension
# todo:
#	- make it so that it works without an extension on the input
function topdf() {
	local output="${1:r}.pdf"
	markdown-pdf $1 -o $output 2> /dev/null
}

# fuzzy find into vim (credit to "bag-man/dotfiles/bashrc")
function fvim() {
  local IFS=$'\n'
  local files=($(fzf --reverse --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && vim "${files[@]}"
}
