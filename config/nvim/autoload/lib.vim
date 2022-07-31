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

" Show help along the screen's larger dimension
function! lib#ShowHelp(tag) abort
    if winheight('%') < ( winwidth('%') / 2 )
        execute 'vertical help ' . a:tag
    else
        execute 'help ' . a:tag
    endif
endfunction

" Store visual selection marks, save, restore visual selection marks
function! lib#SaveAndRestoreVisualSelectionMarks() abort
    let l:fname = expand("%")

    " the intent of this line was to only save existing files, but this is
    " (unintentionally) making things not save when I'd like them to.
    " I think that what I really want is to always save files all the time,
    " but to delete a file that is empty on vim-exit
    " I'm gonna make that a TODO and comment this out for now
    " if filereadable(l:fname) && match(readfile(l:fname), "text")
    if v:true
        let start_mark = getpos("'[")
        let end_mark = getpos("']")

        try
            silent write
        catch
        finally
            call setpos("'[", start_mark)
            call setpos("']", end_mark)
        endtry
    endif
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

"==============================[ AddPluginMapping ]=============================
" Adds a plugin mapping to the normal-mode plugin mapping space
"===============================================================================
function! lib#AddPluginMapping(lhs, rhs)
    let lhs = g:pluginleader . a:lhs
    execute "nnoremap <silent> " lhs a:rhs
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

"===========================[ KillBufferAndGoToNext ]===========================
" does what it says, in a specific order so that Goyo works:
" 1. get current buffer's number
" 2. :bnext
" 3. :bdelete that the previous buffer number
"===============================================================================
function! lib#KillBufferAndGoToNext()
    let l:buffer_number = bufnr('%')
    silent! execute ":bnext"
    silent! execute ":bdelete " . l:buffer_number
endfunction

function lib#findNearestInstanceOfString(string)
    let line = getline('.')

    let col = getcurpos()[2]

    let lineUpToCursor = line[:col - 1]
    let lineAfterCursor = line[col:]

    let indexBeforeCursor = strridx(lineUpToCursor, a:string)
    let indexAfterCursor = stridx(lineAfterCursor, a:string)

    let foundBefore = indexBeforeCursor != -1 ? 1 : 0
    let foundAfter = indexAfterCursor != -1 ? 1 : 0

    if col
        let indexAfterCursor = indexAfterCursor + 1
        let indexBeforeCursor = indexBeforeCursor + 1
    endif

    let indexBeforeCursor = -1 * (col - indexBeforeCursor)

    if foundBefore && foundAfter
        if abs(indexBeforeCursor) <= abs(indexAfterCursor)
            return indexBeforeCursor
        else
            return indexAfterCursor
        endif
    elseif foundBefore
        return indexBeforeCursor
    elseif foundAfter
        return indexAfterCursor
    endif
endfunction

function lib#getTextInsideNearestParenthesis()
    let pos = getcurpos()
    let col = pos[2]

    let distFromOpen = lib#findNearestInstanceOfString('(')
    let distFromClosed = lib#findNearestInstanceOfString(')')

    if abs(distFromOpen) <= abs(distFromClosed)
        let parensCol = col + distFromOpen
    else
        let parensCol = col + distFromClosed
    endif

    let newpos = deepcopy(pos)
    let newpos[2] = parensCol

    call setpos('.', newpos)
    execute ":normal %"
    let otherParensCol = getcurpos()[2]

    call setpos('.', pos)

    let startParensCol = min([parensCol, otherParensCol])
    let endParensCol = max([parensCol, otherParensCol]) - 2 " no idea why it's 2

    let text = getline('.')[startParensCol:endParensCol]

    return text
endfunction
