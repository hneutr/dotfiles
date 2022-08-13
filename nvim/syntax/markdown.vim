" highlight done todos like comments
syn match todoS /^\s*✓\s/ contained
syn region todoI start="^\s*✓\s\+" end="$" containedin=ALL contains=todoS,mkdLink
hi link todoI Comment
hi todoS ctermfg=4

" highlight questions in a particular way∘
syn match qStart /^\s*?\s/ contained
syn region qItem start="^\s*?\s\+" end="$" containedin=ALL contains=qStart,mkdLink
hi qItem ctermfg=11
hi qStart ctermfg=4

" highlight "maybes" in a particular way∘
syn match mStart /^\s*\~\s/ contained
syn region mItem start="^\s*\~\s\+" end="$" containedin=ALL contains=mStart,mkdLink
hi mItem ctermfg=11
hi mStart ctermfg=4
