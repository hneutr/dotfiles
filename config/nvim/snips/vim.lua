local su = require'snips'
local ls = require"luasnip"

ls.add_snippets("vim", su.get_header_snippets('"'))
ls.add_snippets("vim", su.get_print_snippets{ print_fn = 'echo', fn_open = ' ', fn_close = '' })
