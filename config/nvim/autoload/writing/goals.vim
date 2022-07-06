function writing#goals#getGoalsPath()
    let cmd = "python /Users/hne/dotfiles/scripts/python/writing/goals.py"
    let path = system(cmd)
    let path = trim(path)
    return path
endfunction

function writing#goals#openGoals(openCommand)
    call lib#openPath(writing#goals#getGoalsPath(), a:openCommand)
endfunction
