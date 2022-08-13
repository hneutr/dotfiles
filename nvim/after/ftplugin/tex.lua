local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
local cond = require('nvim-autopairs.conds')

npairs.get_rule('`').end_pair = "'"

npairs.add_rules({
    Rule("$$", "$$", "tex"),
    Rule("``", "'", {"tex", "latex"}),
})
