"==================================[ makeLink ]=================================
" creates a markdown link string: [label](reference)
"===============================================================================
function s:makeLink(label, reference)
    return "[" . a:label . "](" . a:reference . ")"
endfunction

function writing#markers#getFileMarkers(path=expand('%'))
    let path = fnamemodify(a:path, ':p')

    let labels = []
    for line in reverse(readfile(path))
        let isMarkerStart = match(line, '[#>] \[') != -1
        let isMarkerEnd = match(line, '.*[\(\)') != -1

        if isMarkerStart && isMarkerEnd
            call add(labels, writing#markers#parseLabel(line))
        endif
    endfor

    return labels
endfunction

function writing#markers#parseLabel(string=getline('.'))
    let string = substitute(a:string, '^.*[', '', '')
    return substitute(string, '](.*).*$', '', '')
endfunction

function writing#markers#parsePath(string=getline(''))
    let string = substitute(a:string, '^.*](', '', '')
    let path = substitute(string, ').*$', '', '')

    if stridx(path, ':') != -1
        let path = split(path, ':')[0]
    endif
    
    return path
endfunction

"================================[ getReference ]===============================
" makes a reference to a marker
"===============================================================================
function writing#markers#getReference(label=writing#markers#parseLabel(), path=expand('%'), copy=1)
    let reference = writing#project#shortenMarkerPath(a:path)

    if len(a:label)
        let reference .= ':' . a:label
    endif

    let link = s:makeLink(a:label, reference)

    if a:copy
        let @" = link
    endif

    return link
endfunction

"==============================[ getFileReference ]=============================
" makes a reference to a path and puts it in the " register
"===============================================================================
function writing#markers#getFileReference(path=expand('%'), copy=1)
    let path = writing#project#shortenMarkerPath(a:path)

    let filename = fnamemodify(a:path, ':t:r')

    let link = s:makeLink(filename, path)

    if a:copy
        let @" = link
    endif

    return link
endfunction


"===========================[ fuzzy-find references ]===========================
function writing#markers#pickReference(handler="writing#markers#putPickedReference")
    let g:projectRoot = b:projectRoot

    let getMarkersCommand = "rg '^[#>] \\[.*\\]\\(\\)$' --no-heading " . b:projectRoot

    let references = []
    for string in systemlist(getMarkersCommand)
        let [path, label] = split(string, ':[#>] \[')
        let path = writing#project#shortenMarkerPath(path, '')
        let label = substitute(label, ']()', '', '')
        call add(references, path . ':' . label)
    endfor

    let getFilesCommand = "fd -tf '' " . b:projectRoot
    for path in systemlist(getFilesCommand)
        let path = writing#project#shortenMarkerPath(path, '')
        call add(references, path)
    endfor

    call sort(references)

    call fzf#run(fzf#wrap({'sink': function(a:handler), 'source': references}))
endfunction

function writing#markers#putPickedReference(pick)
    if stridx(a:pick, ':') != -1
        let [path, label] = split(a:pick, ':')
        let path = writing#project#expandMarkerPath(path)
        let reference = writing#markers#getReference(label, path, 0)
    else
        let path = writing#project#expandMarkerPath(a:pick)
        let reference = writing#markers#getFileReference(path, 0)
    endif
    call nvim_put([reference], 'c', 1, 0)
endfunction

function writing#markers#editPick(pick)
    let b:projectRoot = g:projectRoot
    call writing#markers#gotoReference("edit", "." . a:pick)
endfunction

function writing#markers#splitPick(pick)
    let b:projectRoot = g:projectRoot
    call writing#markers#gotoReference("split", "." . a:pick)
endfunction

function writing#markers#vsplitPick(pick)
    let b:projectRoot = g:projectRoot
    call writing#markers#gotoReference("vsplit", "." . a:pick)
endfunction

"============================[ parseMarkerReference ]===========================
" parses a marker reference.
"
" A marker has the following structure:
" - a full marker: `[label](path:text?=flags)`
" - without flags: `[label](path:text)`
" - without a reference: `[label](path)`
"
" However, only content within the parentheses should be passed to this function
"===============================================================================
function writing#markers#parseMarkerReference(marker)
    let text = ''
    let flags = []

    if stridx(a:marker, ':') != -1
        let [shortPath, text] = split(a:marker, ':')
    else
        let shortPath = a:marker
    endif
    
    let path = writing#project#expandMarkerPath(shortPath)

    if stridx(text, '?=') != -1
        let [text, flagsString] = split(text, '?=')

        for i in range(len(flagsString))
            call add(flags, flagsString[i])
        endfor
    endif

    return [path, text, flags]
endfunction

"===============================[ gotoReference ]===============================
" navigates to a marker.
"===============================================================================
function writing#markers#gotoReference(openCommand, marker=lib#getTextInsideNearestParenthesis())
    let [path, text, flags] = writing#markers#parseMarkerReference(a:marker)

    " if the file isn't the one we're currently editing, open it
    if path != expand('%:p')
        " make the directories leading up to the file if it doesn't exist
        call lib#makeDirectories(path, path[-3:] == '.md')
        call lib#openPath(path, a:openCommand)
    endif

    if len(text)
        let search = '[#>] \[' . text . '\]'

        let @/ = search
        try
            silent execute "normal! nzz"
        catch
        endtry
    endif
endfunction

"================================[ renameMarker ]===============================
" change a marker's text
"===============================================================================
function writing#markers#renameMarker(new, old=writing#markers#parseLabel(), path=expand('%'))
    let cmd = "hnetext rename-marker --path " . a:path
    let cmd .= ' --from_text "' . a:old  . '"'
    let cmd .= ' --to_text "' . a:new  . '"'

    silent call system(cmd)
endfunction


"=================================[ moveMarker ]================================
" change a marker's file
"===============================================================================
function writing#markers#moveMarker(oldMarker, newMarker)
    let cmd = "hnetext move-marker"
    let cmd .= " --from_path " . writing#project#expandMarkerPath(writing#markers#parsePath(a:oldMarker))
    let cmd .= " --from_text '" . writing#markers#parseLabel(a:oldMarker) . "'"
    let cmd .= " --to_path " . writing#project#expandMarkerPath(writing#markers#parsePath(a:newMarker))
    let cmd .= " --to_text '" . writing#markers#parseLabel(a:newMarker) . "'"

    silent call system(cmd)
endfunction
