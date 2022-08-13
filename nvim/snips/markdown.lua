local ls = require"luasnip"
local su = require'snips'
local mds = require'snips.markdown'

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets("markdown", {
    s("mc", mds.link.ls),
    s("h", mds.header.small.ls),
    s("bh", mds.header.big.ls),
    s("mh", mds.link_header.small.ls),
    s("mbh", mds.link_header.big.ls),
    s("bl", mds.divider.big.ls),
    s("l", mds.divider.small.ls),
    s("journal", {
        t("["),
        f(function() return vim.fn.strftime("%Y%m%d") end), t{"]():",
        "",
        ""}, i(1),
        t{"",
        "",
        su.charline()}
    })
})
