let s:markerStartChars = ['# ', '> ', '']

let s:yankedMarkers = {}

"================================[ shortenPath ]================================
" takes a path and abbreviates the project root as `.`
"===============================================================================
function <SID>shortenPath(path=expand('%'))
    let path = fnamemodify(a:path, ':p')
    return substitute(path, b:projectRoot . '/', '', '')
endfunction

"=================================[ expandPath ]================================
" expands a marker path (from `shortenPath`) into a full path
"===============================================================================
function <SID>expandPath(path)
    let path = stridx(a:path, '.') == 0 ? a:path[1:] : a:path

    if stridx(path, '/') == 0
        let path = path[1:]
    endif

    return b:projectRoot . '/' . path
endfunction

"==================================[ makeLink ]=================================
" creates a markdown link string: [label](reference)
"===============================================================================
function <SID>makeLink(label, reference)
    return "[" . a:label . "](" . a:reference . ")"
endfunction

function lex#markers#isMarker(line=getline('.'))
    return match(a:line, '^[#>]\?\s\?\[.\+]\(\)') != -1
endfunction

function lex#markers#parseLabel(string=getline('.'))
    for startChar in s:markerStartChars
        let markerStart = startChar . '['

        if stridx(a:string, markerStart) != 0
            continue
        endif

        let string = a:string[len(markerStart):]

        let labelEnd = ']()'
        let labelEndIndex = stridx(string, labelEnd) 

        if labelEndIndex != -1
            return string[:labelEndIndex - 1]
        endif
    endfor

    return ""
endfunction

function lex#markers#parsePath(string=getline(''))
    let string = substitute(a:string, '^.*](', '', '')
    let path = substitute(string, ').*$', '', '')

    if stridx(path, ':') != -1
        let path = split(path, ':')[0]
    endif

    if stridx(path, './') == 0
        let path = path[2:]
    endif
    
    return path
endfunction

"===================================[ getRef ]==================================
" makes a reference to a marker
"===============================================================================
function lex#markers#getRef(text=lex#markers#parseLabel(), path=expand('%'))
    let reference = <SID>shortenPath(a:path)

    if len(a:text)
        let reference .= ':' . a:text
        let label = a:text
    else
        let label = fnamemodify(a:path, ':t:r')

        if label == "@"
            let label = fnamemodify(a:path, ":p:h:t")
        endif

    endif

    if stridx(label, "-") != -1
        let label = substitute(label, '-', ' ', '')
    endif

    return <SID>makeLink(label, reference)
endfunction

function lex#markers#getReferences()
    let getMarkersCommand = "rg '^[#>] \\[.*\\]\\(\\)$' --no-heading " . b:projectRoot

    let references = []
    for string in systemlist(getMarkersCommand)
        let [path, label] = split(string, ':[#>] \[')
        let path = <SID>shortenPath(path)
        let label = substitute(label, ']()', '', '')
        call add(references, path . ':' . label)
    endfor

    let getFilesCommand = "fd -tf '' " . b:projectRoot
    for path in systemlist(getFilesCommand)
        let path = <SID>shortenPath(path)
        call add(references, path)
    endfor

    call sort(references)
    return references
endfunction

"===========================[ fuzzy-find references ]===========================
function lex#markers#fuzzy(fn)
    let wrap = fzf#wrap({'source': lex#markers#getReferences()})
    let wrap['sink*'] = function(a:fn)
    let wrap['_action'] = {'ctrl-v': 'vsplit', 'ctrl-x': 'split', 'ctrl-t': 'tab split'}
    let wrap['options'] = ' +m -x --ansi --prompt "References: " --expect=ctrl-v,ctrl-x,ctrl-t'
    return fzf#run(wrap)
endfunction

function s:actionFor(command)
    if a:command == 'ctrl-v'
        return 'vsplit'
    elseif a:command == 'ctrl-x'
        return 'split'
    elseif a:command == 'ctrl-t'
        return "tabedit"
    else
        return 'edit'
    endif
endfunction

function! lex#markers#gotoPickSink(lines)
    let cmd = s:actionFor(a:lines[0])
    call lex#markers#gotoReference(cmd, a:lines[1])
endfunction

function! lex#markers#putPickSink(lines)
    call nvim_put([lex#markers#getPick(a:lines[1])], 'c', 1, 0)
endfunction

function lex#markers#putPickInInsertSink(lines)
    let line = getline('.')
    let col = getcurpos()[2]

    if col == len(line)
        let pasteMode = 1
        let insertCmd = 'a'
    else
        let pasteMode = 0
        let insertCmd = 'i'
    endif

    call nvim_put([lex#markers#getPick(a:lines[1])], 'c', pasteMode, 1)
    call nvim_input(insertCmd)
endfunction

function lex#markers#getPick(pick)
    let labelBreakIndex = stridx(a:pick, ':')

    if labelBreakIndex != -1
        let path = a:pick[:labelBreakIndex - 1]
        let text = a:pick[labelBreakIndex + 1:]
    else
        let text = ''
        let path = a:pick
    endif

    return lex#markers#getRef(text, <SID>expandPath(path))
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
function lex#markers#parseMarkerReference(marker)
    let text = ''
    let flags = []

    if stridx(a:marker, ':') != -1
        let [shortPath, text] = split(a:marker, ':')
    else
        let shortPath = a:marker
    endif
    
    let path = <SID>expandPath(shortPath)

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
function lex#markers#gotoReference(openCommand, marker=lib#getTextInsideNearestParenthesis())
    let [path, text, flags] = lex#markers#parseMarkerReference(a:marker)

    " if the file isn't the one we're currently editing, open it
    if path != expand('%:p')
        silent call lib#openPath(path, a:openCommand)
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
function lex#markers#renameMarker(new, old=lex#markers#parseLabel(), path=expand('%'))
    let cmd = "hnetext rename-marker"
    let cmd .= " --path " . a:path
    let cmd .= ' --from_text "' . a:old  . '"'
    let cmd .= ' --to_text "' . a:new  . '"'

    silent call system(cmd)
endfunction

"=================================[ moveMarker ]================================
" change a marker's file
"===============================================================================
function lex#markers#moveMarker(oldMarker, newMarker)
    let cmd = "hnetext move-marker"
    let cmd .= " --from_path " . <SID>expandPath(lex#markers#parsePath(a:oldMarker))
    let cmd .= " --from_text '" . lex#markers#parseLabel(a:oldMarker) . "'"
    let cmd .= " --to_path " . <SID>expandPath(lex#markers#parsePath(a:newMarker))
    let cmd .= " --to_text '" . lex#markers#parseLabel(a:newMarker) . "'"

    call system(cmd)
endfunction

"================================[ refToMarker ]================================
" make a reference into a marker
"===============================================================================
function lex#markers#refToMarker(to_path=expand('%'), marker=lib#getTextInsideNearestParenthesis())
    let [path, text, flags] = lex#markers#parseMarkerReference(a:marker)

    if len(text) == 0
        echo "not moving a file marker"
    endif

    let cmd = "hnetext move-marker"
    let cmd .= " --from_path " . path
    let cmd .= " --from_text '" . text . "'"
    let cmd .= " --to_path " . <SID>expandPath("./" . a:to_path)
    let cmd .= " --to_text '" . text . "'"

    silent call system(cmd)
endfunction

function lex#markers#updateReferences(fromPath, fromText, toPath, toText)
    let cmd = "hnetext update-references"
    let cmd .= " --from_path " . a:fromPath
    let cmd .= " --from_text '" . a:fromText . "'"
    let cmd .= " --to_path " . a:toPath
    let cmd .= " --to_text '" . a:toText . "'"

    silent call system(cmd)
endfunction
