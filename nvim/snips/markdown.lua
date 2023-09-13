local ls = require('luasnip')
local snips = require('snips')
local mds = require('snips.markdown')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

local function get_today() return vim.fn.strftime("%Y%m%d") end

ls.add_snippets("markdown", {
    s("time", f(function() return vim.fn.strftime("%X") end)),
    -- dividers
    s("d", mds.Divider('small'):snippet()),
    s("dm", mds.Divider('medium'):snippet()),
    s("db", mds.Divider('large'):snippet()),
    -- headers
    s("h", mds.Header():snippet()),
    s("hm", mds.Header({size='medium'}):snippet()),
    s("hb", mds.Header({size='large'}):snippet()),
    -- link headers
    -- s("h", mds.LinkHeader():snippet()),
    -- s("hm", mds.LinkHeader({size='medium'}):snippet()),
    -- s("hb", mds.LinkHeader({size='large'}):snippet()),
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

    s("person", {
        t({"is a: "}), i(1, "author"), 
        t({"", "name:", "  first: "}), i(2, ""), 
        t({"", "  middle: "}), i(3, ""),
        t({"", "  last: "}), i(4, ""),
    }),
    s("book", {
        t({"is a: "}), i(1, "book"), 
        t({"", "by: "}), i(2, ""), 
        t({"", "published in: "}), i(3, "YYYY"), 
        t({"", "type: "}), i(4, "read|recommendation"), 
        t({"", "read in: ["}), i(5, "YYYYMM"), t({"]",
           "recommended by: "}), i(6, "someone"), 
    }),
    s("quote", {
        t({"is a: quote",
            "of: "}), i(1, ""), 
        t({"", "on page: "}), i(2, ""),
        t({"", "type: "}), c(3, {
            t('passage'),
            t('description'),
            t('assertion'),
            t('perspective'),
            t('witticism'),
            t('on art'),
            t('observation'),
        }),
        t({"", "remind: "}), c(4, {
            t('false'),
            t('true'),
        }),
        t({"", "", ""}), i(5, ""),
    }),
    s("word", {
        t({"is a: word",
            "of: "}), i(1, ""), 
        t({"", "type: "}), c(2, {
            t('cool'),
            t('unknown'),
        })
    }),
})

vim.keymap.set({"i", "s"}, "<C-n>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-p>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end, {silent = true})
