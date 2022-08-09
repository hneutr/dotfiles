local su = require'snips'
local ls = require"luasnip"

ls.add_snippets("lua", su.get_header_snippets("--"))
ls.add_snippets("lua", su.get_print_snippets{ print_fn = 'vim.pretty_print' })
