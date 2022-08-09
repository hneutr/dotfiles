---------------------------------[ snippets ]-----------------------------------
local su = require'snips'
local ls = require"luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("javascript", {s("print", { t("console.log(JSON.stringify("), i(1, ""), t("))") })})
ls.add_snippets("javascript", su.get_header_snippets("//"))
ls.add_snippets("javascript", su.get_print_snippets{ print_fn = 'console.log' })
