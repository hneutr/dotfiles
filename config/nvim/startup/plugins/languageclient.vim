let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {}

let g:LanguageClient_diagnosticsDisplay = {
	\ 1: { 
		\"name": "Error",
		\"texthl": "ALEError", 
		\"signText": "➤",
		\"signTexthl": "ALEErrorSign",
		\},
	\2: {
		\"name": "Warning",
		\"texthl": "ALEWarning",
		\"signText": "➤",
		\"signTexthl": "ALEWarningSign",
		\},
	\3: {
		\"name": "Information",
		\"texthl": "ALEInfo",
		\"signText": "➤",
		\"signTexthl": "ALEInfoSign",
		\},
	\4: {
		\"name": "Hint",
		\"texthl": "ALEInfo",
		\"signText": "➤",
		\"signTexthl": "ALEInfoSign",
		\},
	\}

" \"signText": "✖", 
" \"signText": "⚠",
" \"signText": "ℹ",

if executable('javascript-typescript-stdio')
	let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
endif

if executable('pyls')
	let g:LanguageClient_serverCommands.python = ['pyls']
endif

augroup LanguageClientConfig
	autocmd!

	" <leader>ld to go to definition
	autocmd FileType javascript,python nnoremap <buffer> <leader>ld :call LanguageClient_textDocument_definition()<cr>
	" <leader>lf to autoformat document
	autocmd FileType javascript,python nnoremap <buffer> <leader>lf :call LanguageClient_textDocument_formatting()<cr>
	" <leader>lh for type info under cursor
	autocmd FileType javascript,python nnoremap <buffer> <leader>lh :call LanguageClient_textDocument_hover()<cr>
	" <leader>lr to rename variable under cursor
	autocmd FileType javascript,python nnoremap <buffer> <leader>lr :call LanguageClient_textDocument_rename()<cr>
	" <leader>lc to switch omnifunc to LanguageClient
	autocmd FileType javascript,python nnoremap <buffer> <leader>lc :setlocal omnifunc=LanguageClient#complete<cr>
	" <leader>ls to fuzzy find the symbols in the current document
	autocmd FileType javascript,python nnoremap <buffer> <leader>ls :call LanguageClient_textDocument_documentSymbol()<cr>
	" Use LanguageServer for omnifunc completion
	autocmd FileType javascript,python setlocal omnifunc=LanguageClient#complete
augroup END
