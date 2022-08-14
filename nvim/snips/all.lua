local ls = require('luasnip')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets("all", {
    s("td", { f(function() return vim.fn.strftime("%Y%m%d") end) }),
    s("tw", {
        f(function()
            local today = vim.fn.strftime("%Y%m%d")
            local today_plus_six_days = vim.fn.strftime("%Y%m%d", vim.fn.localtime() + 518400)
            return today .. "-" .. today_plus_six_days
        end)
    }),
})
