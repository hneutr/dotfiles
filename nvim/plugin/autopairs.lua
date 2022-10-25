require('nvim-autopairs').setup({
    disable_filetype = {"vim", "fzf", "TelescopePrompt"},
})

local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

npairs.add_rule(Rule("_", "_", "markdown"))
npairs.add_rule(Rule("__", "__", "python"))
