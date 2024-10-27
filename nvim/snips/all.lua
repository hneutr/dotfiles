local ls = require('luasnip')

local s = ls.snippet
local f = ls.function_node

ls.add_snippets("all", {
    -- today
    s("td", {f(function() return vim.fn.strftime("%Y%m%d") end)}),
})
