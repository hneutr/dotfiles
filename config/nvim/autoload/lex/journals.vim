let g:onWritingJournal = 'on-writing'

function lex#journals#getJournalFilePath(journal="")
    let cmd = "hnetext journal"

    if exists("b:projectRoot")
        let cmd = cmd . ' -s ' . b:projectRoot
    endif

    if a:journal != ""
        let cmd = cmd . ' -j ' . a:journal
    endif

    let path = system(cmd)
    let path = trim(path)
    return path
endfunction
