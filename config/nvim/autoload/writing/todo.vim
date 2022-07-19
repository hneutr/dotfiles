let s:todoChars = ['- ', '> ']

"=================================[ toggleDone ]================================
" switches list items between dont and not
"===============================================================================
function writing#todo#toggleDone() range
    if a:firstline == a:lastline
        let lines = [getline(".")]
        let lineRange = range(a:firstline, a:lastline)
    else
        let startLine = getpos("'<")[1]
        let endLine = getpos("'>")[1]

        let lines = getline(startLine, endLine)
        let lineRange = range(startLine, endLine)
    endif

    let outermostTodoChar = writing#todo#findOutermostTodoChar(lines)

    for lineNumber in lineRange
        call s:toggleTodoChar(lineNumber, outermostTodoChar)
    endfor
endfunction

function s:toggleTodoChar(lineNumber, oldTodoChar)
    let newTodoChar = s:getOtherTodoChar(a:oldTodoChar)
    let line = getline(a:lineNumber)

    if match(line, '\s*' . a:oldTodoChar) != -1
        let idx = stridx(line, a:oldTodoChar)
        let prefix = ''

        if idx == 0
            let suffix = split(line, a:oldTodoChar)[0]
        else
            let [prefix, suffix] = split(line, a:oldTodoChar)
        endif

        let newLine = prefix . newTodoChar . suffix

        call setline(a:lineNumber, newLine)
    endif
endfunction

function s:getOtherTodoChar(todoChar)
    let index = index(s:todoChars, a:todoChar)

    let newIndex = index ? 0 : 1
    return s:todoChars[newIndex]
endfunction

function writing#todo#findOutermostTodoChar(lines)
    let filteredLines = []
    let smallestIndex = 1000
    let outermostTodoChar = ''
    for line in a:lines
        for todoChar in s:todoChars
            if match(line, '\s*' . todoChar) != -1
                let index = stridx(line, todoChar)

                if index < smallestIndex
                    let smallestIndex = index
                    let outermostTodoChar = todoChar
                endif
            endif
        endfor
    endfor

    return outermostTodoChar
endfunction

