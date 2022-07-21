let g:projectConfigs = {}

"===============================[ setProjectRoot ]==============================
" looks for a `.project` file in the current directory and parent directories.
"===============================================================================
function writing#project#setProjectRoot(path=expand('%:p'))
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
            call writing#mirrors#addMappings(writing#project#getConfig())
            break
        else
            call remove(directoryParts, len(directoryParts) - 1)
        endif
    endwhile
endfunction

function writing#project#getConfig()
    if ! has_key(g:projectConfigs, b:projectConfigFile)
        let config = json_decode(readfile(fnameescape(b:projectConfigFile)))
        let config['root'] = b:projectRoot
        let config = writing#mirrors#applyDefaultsToConfig(config)
        let g:projectConfigs[b:projectConfigFile] = config
    endif

    return g:projectConfigs[b:projectConfigFile]
endfunction

"================================[ pushChanges ]================================
" pushes the project's changes to git
"===============================================================================
function writing#project#pushChanges()
    silent execute ":!git add " . b:projectRoot
    silent execute ":!git commit -m ${TD}"
    silent execute ":!git push"
endfunction

function writing#project#openPath(path, openCommand="edit")
    " make the directories leading up to the file if it doesn't exist
    call lib#makeDirectories(a:path, a:path[-3:] == '.md')
    call lib#openPath(a:path, a:openCommand)
endfunction

"================================[ shortenPath ]================================
" takes a path and abbreviates the project root as `.`
"===============================================================================
function writing#project#shortenMarkerPath(path=expand('%'))
    let path = fnamemodify(a:path, ':p')
    return substitute(path, b:projectRoot . '/', '', '')
endfunction

"=================================[ expandPath ]================================
" expands a marker path (from `writing#project#shortenPath`) into a full
" path
"===============================================================================
function writing#project#expandMarkerPath(path)
    if stridx(a:path, '.') == 0
        let path = a:path[1:]
    else
        let path = a:path
    endif

    if stridx(path, '/') == 0
        let path = path[1:]
    endif

    return b:projectRoot . '/' . path
endfunction
