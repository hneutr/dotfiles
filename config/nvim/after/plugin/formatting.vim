augroup formatting
    autocmd!

    " reset formatting options
    autocmd FileType * setlocal formatoptions=

    " don't autoformat long lines in insert mode
    autocmd FileType * setlocal formatoptions+=l

    " allow formatting of comments with gq
    autocmd FileType * setlocal formatoptions+=q

    " remove comment leader when joining lines
    autocmd FileType * setlocal formatoptions+=j

    " recognize numbered lists and wrap accordingly
    autocmd FileType * setlocal formatoptions+=n

    " continue comments on <cr>
    autocmd FileType * setlocal formatoptions+=r

    " continue comments on o/O
    autocmd FileType * setlocal formatoptions+=o

    " autowrap comments
    autocmd FileType * setlocal formatoptions+=c

    " don't autowrap code
    autocmd FileType * setlocal formatoptions-=t

augroup END
