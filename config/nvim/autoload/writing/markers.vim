"=============================[ shortenMarkerPath ]=============================
" takes a path and abbreviates the project root as `.`
"===============================================================================
function writing#markers#shortenMarkerPath(path=expand('%:p'))
    return substitute(a:path, b:projectRoot, '.', '')
endfunction

"==============================[ expandMarkerPath ]=============================
" expands a marker path (from `writing#markers#expandMarkerPath`) into a full
" path
"===============================================================================
function writing#markers#expandMarkerPath(path)
    return substitute(a:path, '.', b:projectRoot, '')
endfunction

"============================[ MakeMarkerReference ]============================
" makes a reference to a marker
"===============================================================================
function writing#markers#MakeMarkerReference()
    let path = writing#markers#shortenMarkerPath()

    let line = getline('.')
    let line = substitute(line, '^.*[', '', '')
    let markerText = substitute(line, ']()$', '', '')
    let marker = path . ':' . markerText

    let a = @a
    let b = @b
    let @a = markerText
    let @b = marker

    execute "normal! o[a](b)"
    execute "normal! ^"

    let @a = a
    let @b = b
endfunction

"=============================[ MakeFileReference ]=============================
" makes a reference to a path
"===============================================================================
function writing#markers#MakeFileReference()
    let path = writing#markers#shortenMarkerPath()

    let filename = expand('%:t:r')

    let registerA = @a
    let registerB = @b
    let @a = filename
    let @b = path

    execute "normal! o[a](b:)"
    execute "normal! ^"

    let @a = registerA
    let @b = registerB
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
    
    let path = writing#markers#expandMarkerPath(shortPath)

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
