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
    -- dividers
    s("d", mds.Divider('small'):snippet()),
    s("dm", mds.Divider('medium'):snippet()),
    s("db", mds.Divider('large'):snippet()),
    -- headers
    s("H", mds.Header():snippet()),
    s("Hm", mds.Header({size='medium'}):snippet()),
    s("Hb", mds.Header({size='large'}):snippet()),
    -- link headers
    s("h", mds.LinkHeader():snippet()),
    s("hm", mds.LinkHeader({size='medium'}):snippet()),
    s("hb", mds.LinkHeader({size='large'}):snippet()),
    -- links
    s("l", mds.Link():snippet()),
    -- flags
    s("f", mds.Flags():snippet()),
    -- metadata (simple)
    s("m", {
        t({"is a: "}), i(1, ""), 
        t({"", "of: "}), i(2, ""),
        t({"", tostring(mds.Divider('large')), ""}),
    }),
    -- metadata
    s("M", mds.Metadata({size='medium'}):snippet()),
    s("Mb", mds.Metadata({size='large'}):snippet()),
    s("Ms", mds.Metadata({size='small'}):snippet()),
    -- today header
    s("htd", mds.LinkHeader({content = get_today}):snippet()),
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
