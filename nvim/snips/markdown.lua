local ls = require('luasnip')
local snips = require('snips')
local mds = require('snips.markdown')

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
    s("mhtd", {
        t{mds.divider.small.str(), "> ["},
        f(function() return vim.fn.strftime("%Y%m%d") end),  t{"]()",
        mds.divider.small.str(), ""},
        i(1)
    }),
    s("bl", snips.BigLine({comment="#"}):snippet()),
    s("l", snips.SmallLine():snippet()),
    s("journal", {
        t("["),
        f(function() return vim.fn.strftime("%Y%m%d") end), t{"]():",
        "",
        ""}, i(1),
        t{"",
        "",
        string.rep("-", 80), ""}
    }),
    s("quote", {
        t{"-----",
        ""}, i(1, ""), t{":",
        "",
        ""}, i(2, "quote"),
        t{"",
        "",
        "quote"}
    }),
})
