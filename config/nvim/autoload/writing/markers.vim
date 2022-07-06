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
    let label = substitute(string, ']().*$', '', '')
    return label
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
        let @" = 
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
function writing#markers#pickFileReference(path='')
    if ! len(a:path)
        call fzf#run(fzf#wrap({'sink': function('writing#markers#pickFileReference')}))
    else
        let reference = writing#markers#getFileReference(a:path, 0)
        silent call nvim_put([reference], 'l', 0, 0)
    endif
endfunction

function writing#markers#pickReference(pick='')
    if ! len(a:pick)
        let g:markerPathChoice = ''
        call fzf#run(fzf#wrap({'sink': function('writing#markers#pickReference')}))
    elseif ! len(g:markerPathChoice)
        let g:markerPathChoice = a:pick
        let labels = writing#markers#getFileMarkers(a:pick)
        call fzf#run(fzf#wrap({'sink': function('writing#markers#pickReference'), 'source': labels}))
    else
        let reference = writing#markers#getReference(a:pick, g:markerPathChoice, 0)
        call nvim_put([reference], 'l', 0, 0)
        let g:markerPathChoice = ''
    endif
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

"============================[ GoToMarkerReference ]============================
" navigates to a marker.
"===============================================================================
function writing#markers#GoToMarkerReference(openCommand)
    let marker = lib#getTextInsideNearestParenthesis()

    let [path, text, flags] = writing#markers#parseMarkerReference(marker)

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
    let cmd = "writing-project-update --old_path " . a:path
    let cmd .= ' --old_text "' . a:old  . '"'
    let cmd .= ' --new_text "' . a:new  . '"'

    silent call system(cmd)
endfunction
