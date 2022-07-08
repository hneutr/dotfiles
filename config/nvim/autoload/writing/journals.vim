let g:onWritingJournal = 'on-writing'

function writing#journals#getJournalFilePath(journal="")
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

function writing#journals#openJournal(openCommand)
    call lib#openPath(writing#journals#getJournalFilePath(), a:openCommand)
endfunction
