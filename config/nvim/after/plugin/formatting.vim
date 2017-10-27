augroup formatting
		autocmd!

		" continue comments on <cr>
		au FileType * setlocal formatoptions+=r
		" recognize numbered lists and wrap accordingly
		au FileType * setlocal formatoptions+=n
		" don't continue comments on o/O
		au FileType * setlocal formatoptions-=o
augroup END
