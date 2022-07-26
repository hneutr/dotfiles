let g:projectConfigs = {}

"===============================[ setProjectRoot ]==============================
" looks for a `.project` file in the current directory and parent directories.
"===============================================================================
function lex#project#setProjectRoot(path=expand('%:p'))
    if filereadable (a:path)
        let directory = fnamemodify(a:path, ':h')
    else
        let directory = a:path
    endif

    let b:projectRoot = directory

    let directoryParts = split(directory, '/')

    while len(directoryParts) > 0
        let directory = '/' . join(directoryParts, '/')
        let possibleProjectRootFile = directory . '/' . g:projectFileName

        if filereadable (possibleProjectRootFile)
            let b:projectConfigFile = possibleProjectRootFile
            let b:projectRoot = directory
            call lex#mirrors#addMappings(lex#project#getConfig())
            break
        else
            call remove(directoryParts, len(directoryParts) - 1)
        endif
    endwhile
endfunction

function lex#project#getConfig()
    if ! has_key(g:projectConfigs, b:projectConfigFile)
        let config = json_decode(readfile(fnameescape(b:projectConfigFile)))
        let config['root'] = b:projectRoot
        let config = lex#mirrors#applyDefaultsToConfig(config)
        let g:projectConfigs[b:projectConfigFile] = config
    endif

    return g:projectConfigs[b:projectConfigFile]
endfunction

"================================[ pushChanges ]================================
" pushes the project's changes to git
"===============================================================================
function lex#project#pushChanges()
    silent execute ":!git add " . b:projectRoot
    silent execute ":!git commit -m ${TD}"
    silent execute ":!git push"
endfunction
