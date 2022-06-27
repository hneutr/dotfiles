let g:projectFileName = '.project'
let g:scratchPrefix = '.scratch'
let g:indexPrefix = '.indexes'
let g:outlinesPrefix = 'outlines'
let g:possibilitiesPrefix = 'possibilities'
let g:goalsPrefix = '.goals'

"===============================[ setProjectRoot ]==============================
" looks for a `.project` file in the current directory and parent directories.
"
" if it finds it in a directory, it sets `b:projectRoot` to that directory
" otherwise, it sets `b:projectRoot` to the directory of the file.
"===============================================================================
function writing#project#setProjectRoot()
    let directory = expand('%:p:h')

    let b:projectRoot = directory

    let directoryParts = split(directory, '/')

    while len(directoryParts) > 0
        let directory = '/' . join(directoryParts, '/')
        let possibleProjectRootFile = directory . '/' . g:projectFileName

        if filereadable (possibleProjectRootFile)
            let b:projectConfig = directory . '/' . g:projectFileName
            let b:projectRoot = directory
            break
        else
            call remove(directoryParts, len(directoryParts) - 1)
        endif
    endwhile
endfunction

"==========================[ getPrefixedVersionOfPath ]=========================
" gets the equivalent location of a file for a given prefix.
"
" defaults:
" - path: the current file
"
" For example, if: 
" - prefix = `scratch`
" - path = `./text/chapters/1.md` (where "." is the projectRoot)
"
" it will return `./scratch/text/chapters/1.md`
"===============================================================================
function writing#project#getPrefixedVersionOfPath(prefix, path=expand('%:p'))
    let newPath = substitute(a:path, b:projectRoot, '', '')
    let newPath = '/' . a:prefix . newPath
    let newPath = b:projectRoot . newPath
    silent call lib#makeDirectories(newPath, 1)

    return newPath
endfunction

"=========================[ getUnprefixedVersionOfPath ]========================
" gets the "real" location of a file, one with a prefix. For example, the
" defaults:
" - path: the current file
"
" For example, if: 
" - prefix = `scratch`
" - path = `./scratch/text/chapters/1.md` (where "." is the projectRoot)
"
" it will return `./text/chapters/1.md`
"===============================================================================
function writing#project#getUnprefixedVersionOfPath(prefix, path=expand('%:p'))
    let newPath = substitute(a:path, b:projectRoot, '', '')
    let newPath = substitute(newPath, a:prefix . '/', '', '')
    let newPath = b:projectRoot . newPath
    
    return newPath
endfunction

"===============================[ pathIsPrefixed ]==============================
" checks whether the path (minus the project root) starts with the given prefix
" if: 
" - prefix = `scratch`
" - file = `./scratch/text/chapters/1.md` (where "." is the projectRoot)
" it will return a truthy value.
"
" if: 
" - prefix = `scratch`
" - file = `./text/chapters/1.md` (where "." is the projectRoot)
" it will return a falsey value
"===============================================================================
function writing#project#pathIsPrefixed(prefix, path=expand('%:p'))
    let path = substitute(a:path, b:projectRoot . '/', '', '')

    return stridx(path, a:prefix) == 0
endfunction

"======================[ switchBetweenPathAndPrefixedPath ]=====================
" if in the prefixed version of a path, edits the non-prefixed version;
" if in the non-prefixed version of a path, edits the prefixed verseion.
"===============================================================================
function writing#project#switchBetweenPathAndPrefixedPath(prefix, openCommand='edit', path=expand('%:p'))
    if writing#project#pathIsPrefixed(a:prefix, a:path)
        let newPath = writing#project#getUnprefixedVersionOfPath(a:prefix, a:path)
    else
        let newPath = writing#project#getPrefixedVersionOfPath(a:prefix, a:path)
    endif

    silent execute ":" . a:openCommand . " " . fnameescape(newPath)
endfunction

function writing#project#switchTest(prefix, path=expand('%:p'))
    if writing#project#pathIsPrefixed(a:prefix, a:path)
        let newPath = writing#project#getUnprefixedVersionOfPath(a:prefix, a:path)
    else
        let newPath = writing#project#getPrefixedVersionOfPath(a:prefix, a:path)
    endif

    echo fnameescape(newPath)
    " return fnameescape(newPath)
endfunction

"================================[ pushChanges ]================================
" pushes the project's changes to git
"===============================================================================
function writing#project#pushChanges()
    silent execute ":!git add " . b:projectRoot
    silent execute ":!git commit -m ${TD}"
    silent execute ":!git push"
endfunction

"===========================[ addFileOpeningMappings ]==========================
" adds mappings to toggle between project files
"===============================================================================
function writing#project#addFileOpeningMappings(mappingPrefix, directoryPrefix)
    let fn = "writing#project#switchBetweenPathAndPrefixedPath"
    let args = '"' . a:directoryPrefix . '"'

    call lib#mapPrefixedFileOpeningActions(a:mappingPrefix, fn, args)
endfunction
