"===============================[ getScratchFile ]==============================
" gets the scratch directory for a file
"===============================================================================
function writing#scratch#getScratchFile()
    let filename = expand('%:t')
    let directory = expand('%:p:h')

    let scratchDirectory = substitute(directory, b:projectRoot, '', '')
    let scratchDirectory = '/scratch' . scratchDirectory
    let scratchDirectory = b:projectRoot . scratchDirectory
    call lib#makeDirectories(scratchDirectory)

    let scratchFilename = scratchDirectory . '/' . filename
    return scratchFilename
endfunction

function writing#scratch#isScratchFile()
    let directory = expand('%:p:h')
    let directory = substitute(directory, b:projectRoot . '/', '', '')

    return stridx(directory, 'scratch') == 0
endfunction

function writing#scratch#getNonScratchFile()
    let filename = expand('%:t')
    let scratchDirectory = expand('%:p:h')

    let directory = substitute(scratchDirectory, b:projectRoot, '', '')
    let directory = substitute(directory, 'scratch/', '', '')
    let directory = b:projectRoot . directory

    let filename = directory . '/' . filename
    return filename
endfunction

function writing#scratch#openScratchFile(openCommand)
    if writing#scratch#isScratchFile()
        let path = writing#scratch#getNonScratchFile()
    else
        let path = writing#scratch#getScratchFile()
    endif

    execute ":" . a:openCommand . " " . fnameescape(path)
endfunction

"=============================[ moveToScratchFile ]=============================
" moves the selected to the top of the scratch file
"===============================================================================
function writing#scratch#moveToScratchFile() range
    if a:firstline == a:lastline
        let lines = [getline(".")]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
        let lines = getline(line_start, line_end)
        if len(lines) == 0
            return ''
        endif

        let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]

        let lines[0] = lines[0][column_start - 1:]
    endif
    if lines[-1] != ""
        let lines = lines + ['']
    endif

    let tempFile = '/tmp/move-to-scratch-file.md'
    let scratchFile = writing#scratch#getScratchFile()

    for line in lines
        silent execute "!echo '" . line . "' >> " . tempFile
    endfor

    silent execute "!cat " . scratchFile . " >> " . tempFile
    silent execute "!mv " . tempFile . " " . scratchFile

    silent execute a:firstline . "," . a:lastline . "delete"
endfunction
