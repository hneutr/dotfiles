let g:defaultIndexPath = $TMPDIR . 'index.md'

function lex#index#makeIndex(path=expand('%:p'), outpath=g:defaultIndexPath)
    let cmd = "hnetext index"
    let cmd .= " --source " . fnameescape(a:path)
    let cmd .= " --dest " . a:outpath
    silent call system(cmd)
    return a:outpath
endfunction

function lex#index#openIndex(openCommand)
    let projectConfigFile = b:projectConfigFile
    let projectRoot = b:projectRoot
    silent call lib#openPath(lex#index#makeIndex(), a:openCommand)
    let b:projectConfigFile = projectConfigFile
    let b:projectRoot = projectRoot
endfunction
