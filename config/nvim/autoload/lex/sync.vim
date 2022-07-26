"==================================[ syncing ]==================================
" "syncing" is updating references when makes change
"
" there are two kinds of reference updates that we want to handle:
" 1. renames: an existing marker's label changes
" 2. moves: an existing marker is moved from one file to another
"
" RENAMES:
" - we look to see if the existing line contains a marker
" - if it does, and there was a marker with a different label there prior to the edit
" - then we consider that a rename
"
" MOVES:
" - when a marker is deleted from a file, add it to the "deleted" list
" - when a marker is added to another file, check to see if it was in the
"   "deleted" list
" - if so, queue up a "delete move"
" - if a marker is deleted from a file:
"   - remove it from the "delete move" list
"   - add it back onto the "deleted" list
"===============================================================================
" these are in the format: oldLabel: oldPath
let g:deletedMarkers = {}


function lex#sync#bufEnter()
    let b:markers = <SID>readMarkers()
    let b:renamedMarkersNewToOld = {}
    let b:renamedMarkersOldToNew = {}
    let b:deletedMarkers = {}
    let b:createdMarkers = {}
endfunction


function lex#sync#bufChange()
    let newMarkers = <SID>readMarkers()

    let deletedMarkers = []
    for marker in keys(b:markers)
        if ! has_key(newMarkers, marker)
            call add(deletedMarkers, marker)
        endif
    endfor

    let createdMarkers = []
    for marker in keys(newMarkers)
        if ! has_key(b:markers, marker)
            call add(createdMarkers, marker)
        endif
    endfor

    let [createdMarkers, deletedMarkers] = <SID>checkRename(createdMarkers, deletedMarkers)

    call <SID>recordMarkerCreationsAndDeletions(createdMarkers, deletedMarkers)

    let b:markers = newMarkers
endfunction


function lex#sync#bufLeave()
    call <SID>handleCreatedMarkers()
    call <SID>handleDeletedMarkers()
    call <SID>handleRenamedMarkers()
endfunction


function <SID>recordMarkerCreationsAndDeletions(createdMarkers, deletedMarkers)
    for marker in a:deletedMarkers
        let b:deletedMarkers[marker] = v:true

        if has_key(b:createdMarkers, marker)
            call remove(b:createdMarkers, marker)
        endif
    endfor

    for marker in a:createdMarkers
        let b:createdMarkers[marker] = v:true

        if has_key(b:deletedMarkers, marker)
            call remove(b:deletedMarkers, marker)
        endif
    endfor
endfunction


function <SID>handleCreatedMarkers()
    let toPath = expand('%:p')
    for fromText in keys(b:createdMarkers)
        if has_key(b:renamedMarkersOldToNew, fromText)
            let toText = remove(b:renamedMarkersOldToNew, fromText)
            call remove(b:renamedMarkersNewToOld, toText)
        else
            let toText = fromText
        endif

        if has_key(g:deletedMarkers, fromText)
            let fromPath = remove(g:deletedMarkers, fromText)

            call lex#markers#updateReferences(fromPath, fromText, toPath, toText)
        endif
    endfor
    
    let b:createdMarkers = {}
endfunction

function <SID>handleDeletedMarkers()
    let path = expand('%:p')
    for marker in keys(b:deletedMarkers)
        if has_key(b:renamedMarkersNewToOld, marker)
            let marker = remove(b:renamedMarkersNewToOld, marker)
            call remove(b:renamedMarkersOldToNew, marker)
        endif

        let g:deletedMarkers[marker] = path
    endfor

    let b:deletedMarkers = {}
endfunction

function <SID>handleRenamedMarkers()
    let path = expand('%:p')
    for [fromText, toText] in items(b:renamedMarkersOldToNew)
        call lex#markers#updateReferences(path, fromText, path, toText)
    endfor

    let b:renamedMarkersOldToNew = {}
    let b:renamedMarkersNewToOld = {}
endfunction

function <SID>readMarkers()
    let markers = {}
    for lineNumber in range(1, line('$'))
        let line = getline(lineNumber)
        if lex#markers#isMarker(line)
            let label = lex#markers#parseLabel(line)
            let markers[label] = lineNumber
        endif
    endfor

    return markers
endfunction

function <SID>checkRename(createdMarkers, deletedMarkers)
    if len(a:createdMarkers) == 1 && len(a:deletedMarkers) == 1
        let oldLabel = a:deletedMarkers[0]
        let newLabel = a:createdMarkers[0]

        let lineNumber = getpos('.')[1]

        if b:markers[oldLabel] == lineNumber
            if has_key(b:renamedMarkersNewToOld, oldLabel)
                let originalLabel = remove(b:renamedMarkersNewToOld, oldLabel)
            else
                let originalLabel = oldLabel
            endif

            if newLabel == originalLabel
                call remove(b:renamedMarkersOldToNew, originalLabel)
            else
                let b:renamedMarkersNewToOld[newLabel] = originalLabel
                let b:renamedMarkersOldToNew[originalLabel] = newLabel
            endif

            let b:markers[newLabel] = remove(b:markers, oldLabel)

            return [[], []]
        endif
    endif

    return [a:createdMarkers, a:deletedMarkers]
endfunction
