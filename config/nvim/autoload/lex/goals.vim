function lex#goals#getGoalsPath()
    let cmd = "hnetext goals"
    let path = system(cmd)
    let path = trim(path)
    return path
endfunction
