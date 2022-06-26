function writing#goals#getGoalsFilePath()
    let pathCmd = "python /Users/hne/dotfiles/scripts/python/writing/goals.py"
    let filePath = system(pathCmd)
    let filePath = trim(filePath)

    return filePath
endfunction
