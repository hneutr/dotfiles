"==========[ ModifyLineEndDelimiter ]==========
" Description:
"	This function takes a delimiter character and:
"	- removes that character from the end of the line if the character at the end
"	of the line is that character
"	- removes the character at the end of the line if that character is a
"	delimiter that is not the input character and appends that character to
"	the end of the line
"	- adds that character to the end of the line if the line does not end with
"	a delimiter
"
" Delimiters:
" - ","
" - ";"
"==========================================
function! lib#ModifyLineEndDelimiter(character)
	let line_modified = 0
	let line = getline('.')

	for character in [',', ';']
		" check if the line ends in a trailing character
		if line =~ character . '$'
			let line_modified = 1

			" delete the character that matches:

			" reverse the line so that the last instance of the character on the
			" line is the first instance
			let newline = join(reverse(split(line, '.\zs')), '')

			" delete the instance of the character
			let newline = substitute(newline, character, '', '')

			" reverse the string again
			let newline = join(reverse(split(newline, '.\zs')), '')

			" if the line ends in a trailing character and that is the
			" character we are operating on, delete it.
			if character != a:character
				let newline .= a:character
			endif

			break
		endif
	endfor

	" if the line was not modified, append the character
	if line_modified == 0
		let newline = line . a:character
	endif

	call setline('.', newline)
endfunction

function! lib#VisualSelection(direction, extra_filter) range
	let l:saved_reg=@"
	execute "normal! vgvy"

	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")

	let l:command = ''
	if a:direction == 'gv'
		let l:command = "Ag \"" . l:pattern . "\" "
	elseif a:direction == 'replace'
		let l:command = "%s" . '/' . l:pattern . '/'
	endif

	exe "menu Foo.Bar :" . l:command
	emenu Foo.Bar
	unmenu Foo

	let @/ = l:pattern
	let @" = l:saved_reg
endfunction

function! lib#StripTrailingWhitespace()
	normal mZ
	%s/\s\+$//e
	normal `Z
	normal mZ
endfunction

" relative is a boolean indicating either
" --> relativenumber (when true)
" --> norelativenumber (when false)
function! lib#NumberToggle(relative)
	if (&number)
		if (a:relative == 1)
			set relativenumber
		else
			set norelativenumber
		endif
	endif
endfunction

function! lib#FoldDisplayText()                                                         
    let linecount = v:foldend - v:foldstart + 1
    let line = getline(v:foldstart)
    let info = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')

	" indent by the equivalent of a tab
	let preinfospaces = repeat(" ", &shiftwidth - 1)

	" fill the rest of the foldline with spaces
	let postinfospaces = repeat(" ", winwidth(0))

	return preinfospaces . linecount . " lines: " . info . postinfospaces
endfunction

" sets some stuff up for writing
function! lib#UnstructuredText()
	call pencil#init({ 'wrap' : 'hard' })
	setlocal wrap
	setlocal textwidth=80
	setlocal spell
endfunction

" Show help along the screen's larger dimension
function! lib#ShowHelp(tag) abort
	if winheight('%') < ( winwidth('%') / 2 )
		execute 'vertical help ' . a:tag
	else
		execute 'help ' . a:tag
	endif
endfunction

