call lib#AddPluginMapping('l', ':LanguageClientStart<cr>')

let g:LanguageClient_autoStart = 1
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {}

if executable('javascript-typescript-stdio')
	let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
endif

if executable('pyls')
	let g:LanguageClient_serverCommands.python = ['pyls']
endif

augroup LanguageClientConfig
	autocmd!

	" <leader>ld to go to definition
	autocmd FileType javascript,python nnoremap <buffer> <silent> <leader>dld :call LanguageClient_textDocument_definition()<cr>
	" <leader>lh for type info under cursor
	autocmd FileType javascript,python nnoremap <buffer> <silent> <leader>dlh :call LanguageClient_textDocument_hover()<cr>
	" <leader>lr to rename variable under cursor
	autocmd FileType javascript,python nnoremap <buffer> <silent> <leader>dlr :call LanguageClient_textDocument_rename()<cr>
	" <leader>ls to fuzzy find the symbols in the current document
	autocmd FileType javascript,python nnoremap <buffer> <silent> <leader>dls :call LanguageClient_textDocument_documentSymbol()<cr>
	" Use LanguageServer for omnifunc completion
	autocmd FileType javascript,python setlocal omnifunc=LanguageClient#complete
augroup END
