local ls = require('luasnip')
local snips = require('snips')
local mds = require('snips.markdown')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function get_today() return vim.fn.strftime("%Y%m%d") end

ls.add_snippets("markdown", {
    s("time", f(function() return vim.fn.strftime("%X") end)),
    -- lines
    s("l", mds.Divider.from_size('small'):snippet()),
    s("lm", mds.Divider.from_size('medium'):snippet()),
    s("lb", mds.Divider.from_size('big'):snippet()),
    -- headers
    s("h", mds.Header():snippet()),
    s("hm", mds.Header.from_size({size='medium'}):snippet()),
    s("hb", mds.Header.from_size({size='big'}):snippet()),
    -- markers
    s("m", mds.Link():snippet()),
    -- flags
    s("f", mds.Flags():snippet()),
    -- marker headers
    s("mh", mds.LinkHeader():snippet()),
    s("mhm", mds.LinkHeader.from_size({size='medium'}):snippet()),
    s("mhb", mds.LinkHeader.from_size({size='big'}):snippet()),
    -- misc marker headers
    s("mhtd", mds.LinkHeader({inner = get_today}):snippet()),
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
    -- testheaders
    s("th", mds.TestHeader():snippet()),
    s("thm", mds.TestHeader({size='medium'}):snippet()),
    s("thb", mds.TestHeader({size='large'}):snippet()),
})
