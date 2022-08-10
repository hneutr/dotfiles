"==========[ ModifyLineEndDelimiter ]==========
" Description:
"   This function takes a delimiter character and:
"   - removes that character from the end of the line if the character at the
"   end of the line is that character
"   - removes the character at the end of the line if that character is a
"   delimiter that is not the input character and appends that character to
"   the end of the line
"   - adds that character to the end of the line if the line does not end with
"   a delimiter
"
" Delimiters:
" - ","
" - ";"
" - ":"
"==========================================
function! lib#ModifyLineEndDelimiter(character)
    let line_modified = 0
    let line = getline('.')

    for character in [',', ';', ':']
        " check if the line ends in a trailing character
        if line =~ character . '$'
            let line_modified = 1

            " delete the character that matches:

            " reverse the line so that the last instance of the character on the
            " line is the first character
            let newline = join(reverse(split(line, '.\zs')), '')

            " delete the instance of the character
            let newline = substitute(newline, character, '', '')

            " reverse the string again
            let newline = join(reverse(split(newline, '.\zs')), '')

            " if the line ends in a trailing character and that is the
            " character we are operating on, delete it.
            if character != a:character
                    let newline .= a:character
            endif

            break
        endif
    endfor

    " if the line was not modified, append the character
    if line_modified == 0
        let newline = line . a:character
    endif

    call setline('.', newline)
endfunction

function! lib#FoldDisplayText()                                                         
    let linecount = v:foldend - v:foldstart + 1
    let line = getline(v:foldstart)
    let info = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')

    " indent by the equivalent of a tab
    let preinfospaces = repeat(" ", &shiftwidth - 1)

    " fill the rest of the foldline with spaces
    let postinfospaces = repeat(" ", winwidth(0))

    return preinfospaces . linecount . " lines: " . info . postinfospaces
endfunction

" Store visual selection marks, save, restore visual selection marks
function! lib#SaveAndRestoreVisualSelectionMarks() abort
    let start_mark = getpos("'[")
    let end_mark = getpos("']")

    try
        silent write
    catch
    finally
        call setpos("'[", start_mark)
        call setpos("']", end_mark)
    endtry
endfunction

" takes the filetype of the file I'm in and a single argument for 'plugin' or
" 'detect' (defaults to 'plugin') and opens the ftplugin or ftdetect file for
" that filetype
function! lib#OpenFileSettings(...)
    let l:setting_type = 'plugin'
    if a:0 >= 1
        let l:setting_type = a:1
    endif

    if ! (l:setting_type ==# 'plugin' || l:setting_type ==# 'detect')
        return
    endif

    let l:file = expand("~/.config/nvim/ft" . l:setting_type . '/' . &filetype . '.vim')

    execute 'split ' l:file
endfunction

"==============================[ SetNumberDisplay ]=============================
" Varies the display of numbers.
"
" This is not a 'mode' specific setting, so a simple autocommand won't work.
" Numbers should not show up in a terminal buffer, regardless of if that
" buffer is in terminal mode or not.
"===============================================================================
function! lib#SetNumberDisplay()
    if &buftype == 'terminal'
        setlocal nonumber
        setlocal norelativenumber
    else
        set number
        set relativenumber
    endif
endfunction

function lib#setListenAddress(listenAddress=v:servername)
    let $NVIM_LISTEN_ADDRESS = a:listenAddress
endfunction

function lib#editWithoutNesting(listenAddress)
    if a:listenAddress !=# v:servername
        call lib#setListenAddress(a:listenAddress)

        " start a job with the source vim instance
        let g:receiver = jobstart(['nc', '-U', a:listenAddress], {'rpc': v:true})

        " get the filename of the newly opened buffer
        let g:filename = fnameescape(expand('%:p'))

        " wipeout the buffer
        noautocmd bwipeout

        " open the buffer in the source vim instance
        call rpcrequest(g:receiver, "nvim_command", "edit ".g:filename)

        " call the autocommand to enter windows
        call rpcrequest(g:receiver, "nvim_command", "doautocmd BufWinEnter")

        " quit the "other" instance of vim
        quitall
    endif
endfunction

"============================[ TwoVerticalTerminals ]===========================
" Opens two vertical terminals
" I use this from the shell
"===============================================================================
function! lib#TwoVerticalTerminals()
    call lib#setListenAddress()
    execute "silent! terminal"
    execute "silent! <esc>"
    execute "silent! vsplit"
    execute "silent! terminal"
endfunction
