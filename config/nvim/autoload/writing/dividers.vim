function writing#dividers#getHeader(content='', size='small')
    if a:size == 'small'
        let length = 40
        let lineStartChar = '-'
        let textStartChar = '>'
    elseif a:size == 'big'
        let length = 80
        let lineStartChar = '#'
        let textStartChar = '#'
    endif

    let line = lineStartChar
    while len(line) < length
        let line .= '-'
    endwhile

    let contentLine = textStartChar . ' ' . a:content

    return [line, contentLine, line]
endfunction

function writing#dividers#insertMarkerHeader(size='small')
    let header = writing#dividers#getHeader('[]()', a:size)
    silent call nvim_put(header, 'l', 0, 0)

    let pos = getcurpos()
    let pos[1] += 1
    let pos[2] = 4
    call setpos('.', pos)
    startinsert
endfunction
