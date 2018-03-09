augroup formatting
    autocmd!

    " continue comments on <cr>
    autocmd FileType * setlocal formatoptions+=r

    " recognize numbered lists and wrap accordingly
    autocmd FileType * setlocal formatoptions+=n

    " don't continue comments on o/O
    autocmd FileType * setlocal formatoptions-=o

    " autowrap comments
    autocmd FileType * setlocal formatoptions+=c

    " don't autowrap code
    autocmd FileType * setlocal formatoptions-=t

augroup END
