local su = require'snips'
local ls = require"luasnip"

ls.config.set_config({
    -- ensure tab behaves normally outside snips
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave',
})

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

--------------------------------------------------------------------------------
--                           utility functions                                --
--------------------------------------------------------------------------------
local function charline(args)
    args = _G.default_args(args, { char = '-', len = 80, start = '', _end = '' })
    local str = args.start
    while str:len() < args.len - args._end:len() do
        str = str .. args.char
    end

    str = str .. args._end

    return str
end

--------------------------------------------------------------------------------
--                                 snips                                      --
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
--                                markdown                                    --
--------------------------------------------------------------------------------

-- local mds = require'snips.markdown'
-- ls.add_snippets("markdown", {
--     s("mc", mds.link.ls),
--     s("h", mds.header.small.ls),
--     s("bh", mds.header.big.ls),
--     s("mh", mds.link_header.small.ls),
--     s("mbh", mds.link_header.big.ls),
--     s("bl", mds.divider.big.ls),
--     s("l", mds.divider.small.ls),
--     s("journal", {
--         t("["),
--         f(function() return vim.fn.strftime("%Y%m%d") end), t{"]():",
--         "",
--         ""}, i(1),
--         t{"",
--         "",
--         charline{ char = '-' }}
--     })
-- })
