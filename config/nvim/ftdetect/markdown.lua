local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

local p = { "*.md" }

vim.o.ft = 'markdown'
vim.g.vim_markdown_no_default_key_mappings = 1

local lex = augroup('lex_cmds', { clear = true })

aucmd({"BufNewFile", "BufRead"}, { pattern=p, group=lex, callback=require'lex.config'.set })
aucmd({'BufEnter'}, { pattern=p, group=lex, callback=require'lex.map'.add_mappings })
aucmd({'BufEnter'}, { pattern=p, group=lex, callback=require'lex.sync'.buf_enter })
aucmd({'TextChanged', 'InsertLeave'}, { pattern=p, group=lex, callback=require'lex.sync'.buf_change })
aucmd({'BufLeave', 'VimLeave'}, { pattern=p, group=lex, callback=require'lex.sync'.buf_leave })
