let s:toggleChars = ['-', '✓', '?', '~'] "∘
let s:defaultChar = '-'

"=================================[ toggleDone ]================================
" switches list items between dont and not
"===============================================================================
function lex#todo#toggleDone(toggleChar) range
    if a:firstline == a:lastline
        let lines = [getline(".")]
        let lineRange = range(a:firstline, a:lastline)
    else
        let startLine = getpos("'<")[1]
        let endLine = getpos("'>")[1]

        let lines = getline(startLine, endLine)
        let lineRange = range(startLine, endLine)
    endif

    let outermostToggleChar = lex#todo#findOutermostToggleChar(lines)

    if len(outermostToggleChar) > 0
        let newToggleChar = outermostToggleChar == a:toggleChar ? s:defaultChar : a:toggleChar

        for lineNumber in lineRange
            call s:setToggleChar(lineNumber, newToggleChar)
        endfor
    endif
endfunction

function s:setToggleChar(lineNumber, newToggleChar)
    let line = getline(a:lineNumber)

    let whitespace = len(line) - len(trim(line))

    let char = <SID>getToggleChar(line)

    if char != -1 && char != a:newToggleChar
        let index = stridx(line, char)

        let newLine = index > 0 ? line[:index - 1] : ""
        let newLine .= a:newToggleChar . line[index + len(char):]
        call setline(a:lineNumber, newLine)
    endif
endfunction

function lex#todo#findOutermostToggleChar(lines)
    let smallestIndent = 1000
    let outermostToggleChar = ''
    for line in a:lines
        let char = <SID>getToggleChar(line)

        if char != -1
            let indent = len(line) - len(trim(line))

            if indent < smallestIndent
                let smallestIndent = indent
                let outermostToggleChar = char
            endif
        endif
    endfor

    return outermostToggleChar
endfunction

function <SID>getToggleChar(line)
    let line = trim(a:line)
    for char in s:toggleChars
        if stridx(line, char) == 0
            return char
        endif
    endfor

    return -1
endfunction
