function writing#goals#getGoalsPath()
    let cmd = "hnetext goals"
    let path = system(cmd)
    let path = trim(path)
    return path
endfunction

function writing#goals#openGoals(openCommand)
    call lib#openPath(writing#goals#getGoalsPath(), a:openCommand)
endfunction
