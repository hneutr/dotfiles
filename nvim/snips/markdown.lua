local ls = require('luasnip')
local snips = require('snips')
local mds = require('snips.markdown')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local ps = ls.parser.parse_snippet

local extras = require('luasnip.extras')
local fmt = require("luasnip.extras.fmt").fmt

local function get_today() return vim.fn.strftime("%Y%m%d") end
local today_s = extras.partial(os.date, "%Y%m%d")

ls.add_snippets("markdown", {
    ps("l", "[$1]($2)"),
    -- dividers
    s("d", mds.Divider('small'):snippet()),
    s("dm", mds.Divider('medium'):snippet()),
    s("dl", mds.Divider('large'):snippet()),
    mds.divider_s("D", "small"),
    mds.divider_s("DM", "medium"),
    -- headers
    ps("hl", mds.header("large")),
    ps("hm", mds.header("medium")),
    ps("h", mds.header()),
    ps("hs", mds.header("small")),
    ps("Hl", mds.link_header("large")),
    ps("Hm", mds.link_header("medium")),
    ps("H", mds.link_header()),
    ps("Hs", mds.link_header("small")),
    -- metadata (simple)
    s("m", {
        t({"is a: "}), i(1, ""), 
        t({"", "of: "}), i(2, ""),
        t({"", tostring(mds.Divider('large')), ""}),
    }),
    -- misc
    ps("person", [[
        first name: $1
        middle name: $2
        last name: $3
    ]]),
    ps("book", [[
        is a: book
        by: $1
        published in: ${2:YYYY}
        type: ${3|read,recommendation|}
        read in: ${4:YYYY}
        recommended by: $5
    ]]),
    ps("quote", [[
        is a: quote
        of: $1
        on page: $2
        type: ${3|passage,description,assertion,perspective,witticism,on art,observation|}
        remind: ${4|false,true|}

        $5
    ]]),
    s("d", {
        t('date: '),
        f(get_today),
        t({"", ""}),
    }),
    ps("t", "@: $1"),
    s("thought", fmt(
        [[
            date: {today}
            is a: {i1}
            @: {i2}
        ]],
        {today = today_s, i1 = i(1, ""), i2 = i(2, "tag")})
    ),
    ps("word", [[
        is a: word
        of: $1
        type: ${2|cool,unknown|}
    ]]),
})

vim.keymap.set({"i", "s"}, "<C-.>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-,>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end, {silent = true})
