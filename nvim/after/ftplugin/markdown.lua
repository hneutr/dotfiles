local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

npairs.add_rule(Rule("_","_","markdown"))

vim.keymap.set("i", "<cr>", require('list').continue_list_command, {silent = true})
