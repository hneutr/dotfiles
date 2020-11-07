" lua <<EOF
" require'nvim_lsp'.pyls.setup{on_attach=require'completion'.on_attach}
" EOF

" let g:completion_enable_snippet = 'UltiSnips'

" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
