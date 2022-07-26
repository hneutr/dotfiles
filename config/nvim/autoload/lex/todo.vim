let s:toggleChars = ['- ', '✓ ', '? ', '~ '] "∘
let s:defaultChar = '- '

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

    for oldToggleChar in s:toggleChars
        if match(line, '\s*' . oldToggleChar) != -1
            let idx = stridx(line, oldToggleChar)
            let prefix = ''

            if idx == 0
                let suffix = split(line, oldToggleChar)[0]
            else
                let [prefix, suffix] = split(line, oldToggleChar)
            endif

            let newLine = prefix . a:newToggleChar . suffix

            call setline(a:lineNumber, newLine)
            return
        endif
    endfor
endfunction

function lex#todo#findOutermostToggleChar(lines)
    let filteredLines = []
    let smallestIndex = 1000
    let outermostToggleChar = ''
    for line in a:lines
        for char in s:toggleChars
            if match(line, '\s*' . char) != -1
                let index = stridx(line, char)

                if index < smallestIndex
                    let smallestIndex = index
                    let outermostToggleChar = char
                endif
            endif
        endfor
    endfor

    return outermostToggleChar
endfunction

