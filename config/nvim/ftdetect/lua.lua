vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, { pattern={ "*.lua" }, callback=function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
end})

---------------------------------[ snippets ]-----------------------------------
local su = require'snips'
local ls = require"luasnip"

ls.add_snippets("lua", su.get_header_snippets("--"))
ls.add_snippets("lua", su.get_print_snippets{ print_fn = 'vim.pretty_print' })
