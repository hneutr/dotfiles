function lex#map#mapPrefixedFileOpeners(prefix, fn, args='', cmds={'edit': 'e', 'vsplit': 'vs', 'split': 'sp'})
    let LHSPrefix = g:fileOpeningPrefix . a:prefix
    let RHSStart = ':call ' . a:fn . '('
    let RHSEnd = ")<cr>"

    if len(a:args)
        let RHSStart .= a:args . ', '
    endif

    let mappings = []

    if has_key(a:cmds, 'edit')
        call add(mappings, ["o", a:cmds.edit])
        call add(mappings, ["e", a:cmds.edit])
    endif

    if has_key(a:cmds, 'vsplit')
        call add(mappings, ["l", a:cmds.vsplit])
        call add(mappings, ["v", a:cmds.vsplit])
    endif

    if has_key(a:cmds, 'split')
        call add(mappings, ["j", a:cmds.split])
        call add(mappings, ["s", a:cmds.split])
    endif

    for [key, cmd] in mappings
        let LHS = LHSPrefix . key
        let RHS = RHSStart . '"' . cmd . '"' . RHSEnd

        silent execute "nnoremap <silent> <buffer> " . LHS . " " . RHS
    endfor
endfunction
