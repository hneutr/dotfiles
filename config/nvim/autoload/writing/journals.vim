function writing#journals#getJournalFilePath()
    if exists("g:projectConfig")
        let journalString = system("grep name= " . g:projectConfig)
    else
        let journalString = ''
    endif

    let journalPathCmd = "python /Users/hne/dotfiles/scripts/python/writing/journaler.py "

    if len(journalString)
        let journalString = substitute(journalString, 'name=', '', '')
        let journalPathCmd = journalPathCmd . journalString
    endif

    let journalFilePath = system(journalPathCmd)
    let journalFilePath = trim(journalFilePath)

    return journalFilePath
endfunction
