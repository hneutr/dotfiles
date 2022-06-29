function writing#journals#getJournalFilePath()
    let journalPathCmd = "python /Users/hne/dotfiles/scripts/python/writing/journaler.py "

    if exists("b:projectRoot")
        let journalPathCmd = journalPathCmd . '-s ' . b:projectRoot
    endif

    let journalFilePath = system(journalPathCmd)
    let journalFilePath = trim(journalFilePath)

    return journalFilePath
endfunction
