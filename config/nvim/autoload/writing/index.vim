let g:defaultIndexPath = $TMPDIR . 'index.md'

function writing#index#makeIndex(path=expand('%:p'), outpath=g:defaultIndexPath)
    let cmd = "hnetext index"
    let cmd .= " --source " . fnameescape(a:path)
    let cmd .= " --dest " . a:outpath
    call system(cmd)
    return a:outpath
endfunction

function writing#index#openIndex(openCommand)
    call lib#openPath(writing#index#makeIndex(), a:openCommand)
endfunction
