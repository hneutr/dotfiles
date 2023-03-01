local ls = require('luasnip')
local snips = require('snips')
local mds = require('snips.markdown')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function get_today() return vim.fn.strftime("%Y%m%d %X") end

ls.add_snippets("markdown", {
    s("time", f(function() return vim.fn.strftime("%X") end)),
    -- lines
    s("l", mds.Divider():snippet()),
    s("lm", mds.Divider({size='medium'}):snippet()),
    s("lb", mds.Divider({size='big'}):snippet()),
    -- headers
    s("h", mds.Header():snippet()),
    s("hm", mds.Header({size='medium'}):snippet()),
    s("hb", mds.Header({size='big'}):snippet()),
    -- markers
    s("m", mds.Link():snippet()),
    -- marker headers
    s("mh", mds.LinkHeader():snippet()),
    s("mhm", mds.LinkHeader({size='medium'}):snippet()),
    s("mhb", mds.LinkHeader({size='big'}):snippet()),
    -- misc marker headers
    s("mhtd", mds.LinkHeader({inner=get_today}):snippet()),
    s("mhtdb", mds.LinkHeader({size='big', inner=get_today}):snippet()),
    -- misc
    s("journal", mds.Journal():snippet()),
    s("quote", {
        t{"---",
        ""}, i(1, ""), t{":",
        "",
        ""}, i(2, "quote"),
        t{"",
        "",
        "quote"}
    }),
})
