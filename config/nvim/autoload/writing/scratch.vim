"=============================[ moveToScratchFile ]=============================
" moves the selected to the top of the scratch file
"===============================================================================
function writing#scratch#moveToScratchFile() range
    if a:firstline == a:lastline
        let lines = [getline(".")]
    else
        let startLine = getpos("'<")[1]
        let endLine = getpos("'>")[1]

        let lines = getline(startLine, endLine)
    endif

    if lines[-1] != ""
        let lines += ['']
    endif

    let scratchFile = writing#project#getPrefixedVersionOfPath('.scratch')

    let newLines = lines + readfile(scratchFile)
    call writefile(newLines, scratchFile)

    silent execute a:firstline . "," . a:lastline . "delete"
endfunction
