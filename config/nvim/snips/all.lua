local ls = require"luasnip"

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets("all", {
    s("quote", {
        t{"-----",
        ""}, i(1, ""), t{":",
        "",
        ""}, i(2, "quote"),
        t{"",
        "",
        "quote"}
    }),
    s("td", { f(function() return vim.fn.strftime("%Y%m%d") end) }),
    s("tw", {
        f(function()
            local today = vim.fn.strftime("%Y%m%d")
            local today_plus_six_days = vim.fn.strftime("%Y%m%d", vim.fn.localtime() + 518400)
            return today .. "-" .. today_plus_six_days
        end)
    }),
    -- close things
    s({ trig = "(", wordTrig = false }, { t '(', i(1), t ')' }),
    s({ trig = "[", wordTrig = false }, { t '[', i(1), t ']' }),
    s({ trig = "{", wordTrig = false }, { t '{', i(1), t '}' }),
    s({ trig = "<", wordTrig = false }, { t '<', i(1), t '>' }),
    s({ trig = "'", wordTrig = false }, { t "'", i(1), t "'" }),
    s({ trig = '"', wordTrig = false }, { t '"', i(1), t '"' }),
    s({ trig = '`', wordTrig = false }, { t '`', i(1), t '`' }),
    s({ trig = '_', wordTrig = false }, { t '_', i(1), t '_' }),
    s({ trig = '__', wordTrig = false }, { t '__', i(1), t '__' }),
    s({ trig = '*', wordTrig = false }, { t '*', i(1), t '*' }),
    s({ trig = '**', wordTrig = false }, { t '**', i(1), t '**' }),
    s({ trig = '$', wordTrig = false }, { t '$', i(1), t '$' }),
})
