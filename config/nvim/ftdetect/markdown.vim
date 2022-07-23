augroup markdown_startup
	autocmd!
	
	au BufNewFile,BufRead *.md call writing#project#setProjectRoot()

	" highlight done todos like comments
	au BufNewFile,BufRead *.md syn match todoS /^\s*✓\s/ contained
	au BufNewFile,BufRead *.md syn region todoI start="^\s*✓\s\+" end="$" containedin=ALL contains=todoS,mkdLink
	au BufNewFile,BufRead *.md hi link todoI Comment
	au BufNewFile,BufRead *.md hi todoS ctermfg=4

	" highlight questions in a particular way∘
	au BufNewFile,BufRead *.md syn match qStart /^\s*?\s/ contained
	au BufNewFile,BufRead *.md syn region qItem start="^\s*?\s\+" end="$" containedin=ALL contains=qStart,mkdLink
	au BufNewFile,BufRead *.md hi qItem ctermfg=11
	au BufNewFile,BufRead *.md hi qStart ctermfg=4

	au TextChanged,InsertLeave *.md call writing#markers#updateReferencesOnLabelChange()
augroup END
