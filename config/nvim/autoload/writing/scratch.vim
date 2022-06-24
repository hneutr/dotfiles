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
    let scratchFile = writing#project#getPrefixedVersionOfPath(g:scratchPrefix)

    for line in lines
        silent execute "!echo '" . line . "' >> " . tempFile
    endfor

    silent execute "!cat " . scratchFile . " >> " . tempFile
    silent execute "!mv " . tempFile . " " . scratchFile

    silent execute a:firstline . "," . a:lastline . "delete"
endfunction
