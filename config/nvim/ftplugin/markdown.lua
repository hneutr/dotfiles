local util = require'util'

vim.g.config_file_name = '.project'
vim.g.writing_journal = 'on-writing'
vim.g.mirror_defaults_path = "/Users/hne/Documents/research/hnetext/data/mirror-defaults.json"
vim.g.file_opening_prefix = "<leader>o"

------------------------------------- config -----------------------------------
vim.api.nvim_create_user_command("Push", function() require'lex.config'.push() end, {})

------------------------------------ journals ----------------------------------
vim.api.nvim_create_user_command("Journal", function() util.open_path(require'lex.journal'.path()) end, {})
vim.api.nvim_create_user_command("WJournal", function() util.open_path(require'lex.journal'.path(vim.g.writing_journal)) end, {})

------------------------------------- goals ------------------------------------
vim.api.nvim_create_user_command("Goals", function() util.open_path(require'lex.goals'.path()) end, {})

------------------------------------ scratch -----------------------------------
-- delete the currently selected lines and move them to the scratch file
vim.keymap.set("n", "<leader>s", function() require'lex.scratch'.move('n') end, {silent = true})
-- (can't get visual range stuff to work right now)
