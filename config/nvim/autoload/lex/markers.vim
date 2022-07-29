let g:marker_path_text_delimiter = ':'
let g:marker_text_flags_delimiter = "?="
let g:directory_filename = "@"

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

"===============================================================================
"===================================[ links ]===================================
"===============================================================================
function <SID>getLink(label, location)
    return "[" . a:label . "](" . a:location . ")"
endfunction

function <SID>parseLink(string)
    let startIndex = stridx(a:string, '[')
    let endIndex = stridx(a:string, ')')

    let string = a:string[startIndex + 1:endIndex - 1]

    let labelLocationDelimiterIndex = stridx(string, '](')

    if labelLocationDelimiterIndex == len(string) - 2
        let label = string[:labelLocationDelimiterIndex - 1]
        let location = ""
    else
        let [label, location] = split(string, '](')
    endif

    return [label, location]
endfunction

"===============================================================================
"==================================[ markers ]==================================
"===============================================================================
" a marker has the following structure:
" [label]()
"
" a marker can be preceded by:
" - "# "
" - "> "
" - "" (nothing)
"
" nothing should follow the marker

function lex#markers#isMarker(line=getline('.'))
    return match(a:line, '^[#>]\?\s\?\[.\+]\(\)') != -1
endfunction

function lex#markers#parseLabel(string=getline('.'))
    return <SID>parseLink(a:string)[0]
endfunction

"===============================================================================
"=================================[ locations ]=================================
"===============================================================================
" a location has he following structure: `path:text?=flags`
" flags and text are optional

function <SID>getLocation(path, text='', flags=[])
    let location = <SID>shortenPath(a:path)

    if len(a:text) > 0
        let location .= g:marker_path_text_delimiter . a:text
    endif

    if len(a:flags) > 0
        let location .= g:marker_text_flags_delimiter . join(a:flags, "")
    endif

    return location
endfunction

function <SID>parseLocation(reference)
    let path = a:reference
    let text = ''
    let flags = []

    let pathTextDelimiterIndex = stridx(path, g:marker_path_text_delimiter)

    if pathTextDelimiterIndex != -1
        let text = path[pathTextDelimiterIndex + 1:]
        let path = path[:pathTextDelimiterIndex - 1]
    endif

    let path = <SID>expandPath(path)

    let textFlagsDelimiterIndex = stridx(text, g:marker_text_flags_delimiter)

    if textFlagsDelimiterIndex != -1
        let flags = text[pathTextDelimiterIndex + 2:]
        let text = text[:pathTextDelimiterIndex - 1]

        for i in range(len(flagsString))
            call add(flags, flagsString[i])
        endfor
    endif

    return [path, text, flags]
endfunction

function lex#markers#gotoLocation(openCommand, marker=lib#getTextInsideNearestParenthesis())
    let [path, text, flags] = <SID>parseLocation(a:marker)

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

function <SID>getLocationsList()
    let getMarkersCommand = "rg '^[#>] \\[.*\\]\\(\\)$' --no-heading " . b:projectRoot

    let references = []
    for string in systemlist(getMarkersCommand)
        let [path, label] = split(string, ':[#>] \[')
        let path = <SID>shortenPath(path)
        let label = substitute(label, ']()', '', '')
        call add(references, path . g:marker_path_text_delimiter . label)
    endfor

    let getFilesCommand = "fd -tf '' " . b:projectRoot
    for path in systemlist(getFilesCommand)
        let path = <SID>shortenPath(path)
        call add(references, path)
    endfor

    call sort(references)
    return references
endfunction

"===============================================================================
"=================================[ references ]================================
"===============================================================================
function lex#markers#getRef(text=lex#markers#parseLabel(), path=expand('%'))
    let location = <SID>getLocation(a:path, a:text)

    if len(a:text)
        let label = a:text
    else
        let label = fnamemodify(a:path, ':t:r')

        if label == g:directory_filename
            let label = fnamemodify(a:path, ":p:h:t")
        endif
    endif

    if stridx(label, "-") != -1
        let label = substitute(label, '-', ' ', '')
    endif

    return <SID>getLink(label, location)
endfunction

"==============================[ updateReferences ]=============================
" references is a list of dicts like so:
"   - old_path
"   - old_text
"   - new_path
"   - new_text
"===============================================================================
function lex#markers#updateReferences(references)
    let cmd = "hnetext update-references"
    let cmd .= " --references '" . json_encode(a:references) . "'"

    silent call system(cmd)
endfunction

"===============================================================================
"===============================[ fuzzy finding ]===============================
"===============================================================================
function lex#markers#fuzzy(fn)
    let wrap = fzf#wrap({'source': <SID>getLocationsList()})
    let wrap['sink*'] = function(a:fn)
    let wrap['_action'] = {'ctrl-v': 'vsplit', 'ctrl-x': 'split', 'ctrl-t': 'tab split'}
    let wrap['options'] = ' +m -x --ansi --prompt "References: " --expect=ctrl-v,ctrl-x,ctrl-t'
    return fzf#run(wrap)
endfunction

function <SID>actionFor(command)
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

function lex#markers#gotoPickSink(lines)
    let cmd = <SID>actionFor(a:lines[0])
    call lex#markers#gotoLocation(cmd, a:lines[1])
endfunction

function lex#markers#putPickSink(lines)
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
    let [path, text, flags] = <SID>parseLocation(a:pick)
    return lex#markers#getRef(text, path)
endfunction
