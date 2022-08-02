local pattern = {"*.md"}
local sync = require'lex.sync'

local function ftset()
    vim.o.ft = 'markdown'
    vim.g.vim_markdown_no_default_key_mappings = 1
    require'lex.config'.set()
end

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, { pattern=pattern, callback=ftset })
vim.api.nvim_create_autocmd({'BufEnter'}, { pattern=pattern, callback=sync.buf_enter })
vim.api.nvim_create_autocmd({'TextChanged', 'InsertLeave'}, { pattern=pattern, callback=sync.buf_change })
vim.api.nvim_create_autocmd({'BufLeave', 'VimLeave'}, { pattern=pattern, callback=sync.buf_leave })
