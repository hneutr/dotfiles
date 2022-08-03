local util = require'util'

local cmd = vim.api.nvim_create_user_command
local map = vim.keymap.set

--------------------------------------------------------------------------------
-- commands
--------------------------------------------------------------------------------
cmd("Push", function() require'lex.config'.push() end, {})
cmd("Journal", function() util.open_path(require'lex.journal'.path()) end, {})
cmd("WJournal", function() util.open_path(require'lex.journal'.path('on-writing')) end, {})
cmd("Goals", function() util.open_path(require'lex.goals'.path()) end, {})
cmd("Index", function() require'lex.index'.open() end, {})

--------------------------------------------------------------------------------
-- mappings
--------------------------------------------------------------------------------

------------------------------------ scratch -----------------------------------
-- map("n", "<leader>s", function() require'lex.scratch'.move('n') end, {silent = true})
-- delete the currently selected lines and move them to the scratch file
-- (can't get visual range stuff to work right now)
