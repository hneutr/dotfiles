function writing#index#create(path=expand('%:p'))
    let command = "!python3 /Users/hne/dotfiles/scripts/python/writing/index.py --source "
    silent execute command . fnameescape(a:path)
endfunction

function writing#index#toggleIndex(openCommand='edit', path=expand('%:p'))
    if ! writing#project#pathIsPrefixed(g:indexPrefix, a:path)
        silent call writing#index#create(a:path)
    endif

    silent call writing#project#switchBetweenPathAndPrefixedPath(g:indexPrefix, a:openCommand, a:path)
endfunction

function writing#index#toggleDirectoryIndex(openCommand='edit', path=expand('%:p:h'))
    if ! writing#project#pathIsPrefixed(g:indexPrefix, a:path)
        silent call writing#index#create(a:path)
        let path = a:path . '/index.md'
    else
        let path = a:path
    endif

    silent call writing#project#switchBetweenPathAndPrefixedPath(g:indexPrefix, a:openCommand, path)
endfunction

function writing#index#fileIndexHeader()
    let headerLine = "#-------------------------------------------------------------------------------"
    return [headerLine, '# index', headerLine]
endfunction

function writing#index#fileHasIndex()
    let indexHeader = writing#index#fileIndexHeader()
    for i in range(len(indexHeader))
        if getline(i + 1) != indexHeader[i]
            return 0
        endif
    endfor

    return 1
endfunction

function writing#index#fileIndexEnd()
    let end = line('$')
    for i in range(5, end)
        if len(getline(i)) == 0
            return i
        endif
    endfor

    return end
endfunction

function writing#index#deleteFileIndex()
    let indexEnd = writing#index#fileIndexEnd()
    silent execute ":1," . indexEnd . "delete"

endfunction

function writing#index#insertIndex(indexType='file')
    if writing#index#fileHasIndex()
        silent call writing#index#deleteFileIndex()
    endif

    let indexContent = writing#index#fileIndexHeader() + ['']

    if (a:indexType == 'directory') || (a:indexType == 'both')
        let indexContent += writing#index#getIndexContent('directory')
    endif

    if a:indexType == 'both'
        let indexContent += [">-------------------------------------------------------------------------------"]
    endif

    if (a:indexType == 'file') || (a:indexType == 'both')
        let indexContent += writing#index#getIndexContent('file')
    endif

    let indexContent += ['']

    silent execute "normal! gg"

    silent call nvim_put(indexContent, 'l', 0, 0)
endfunction

function writing#index#getIndexContent(indexType='file')
    if a:indexType == 'file'
        let indexSourceFile = expand('%:p')
        let indexFile = indexSourceFile
    else
        let indexSourceFile = expand('%:p:h')
        let indexFile = indexSourceFile . '/index.md'
    endif

    silent call writing#index#create(indexSourceFile)
    let indexFile = writing#project#getPrefixedVersionOfPath(g:indexPrefix, indexFile)

    return readfile(fnameescape(indexFile))
endfunction
