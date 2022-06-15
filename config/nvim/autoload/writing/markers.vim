"============================[ MakeMarkerReference ]============================
" makes a reference to a marker
"
" if `crossFile` is 1, it'll make it a cross file reference.
"===============================================================================
function writing#markers#MakeMarkerReference()
    let path = expand('%:p')
    let path = substitute(path, g:projectRoot, '.', '')

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
    let path = expand('%:p')
    let path = substitute(path, g:projectRoot, '.', '')

    let register = @a
    let @a = path

    execute "normal! o[a](a:)"
    execute "normal! ^"

    let @a = register
endfunction

"============================[ GoToMarkerReference ]============================
" navigates to a marker.
"===============================================================================
function writing#markers#GoToMarkerReference(openCommand)
    " currently will just take first marker on line
    let line = getline('.')
    let line = substitute(line, '^.*(', '', '')
    let marker = substitute(line, ').*$', '', '')

    if stridx(marker, ':') != -1
        let path = substitute(marker, ':.*$', '', '')
        let marker = substitute(marker, '^.*:', '', '')

        if path =~ '^\.'
            let path = substitute(path, '.', '', '')
            let path = g:projectRoot . path
        endif

        execute ":" . a:openCommand . " " . fnameescape(path)
    endif

    if len(marker) > 0
        let search = '[#>] \[' . marker . '\]'

        let @/ = search
        try
            execute "normal! nzz"
        catch
        endtry
    endif
endfunction
