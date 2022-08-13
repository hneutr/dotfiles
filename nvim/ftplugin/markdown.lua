--------------------------------------------------------------------------------
-- commands
--------------------------------------------------------------------------------
local util = require'util'
local cmd = vim.api.nvim_create_user_command

cmd("Push", function() require'lex.config'.push() end, {})
cmd("Journal", function() util.open_path(require'lex.journal'.path({ journal = 'catch all' })) end, {})
cmd("PJournal", function() util.open_path(require'lex.journal'.path()) end, {})
cmd("WJournal", function() util.open_path(require'lex.journal'.path({ journal = 'on writing'})) end, {})
cmd("Goals", function() util.open_path(require'lex.goals'.path()) end, {})
cmd("Index", function() require'lex.index'.open() end, {})

--------------------------------------------------------------------------------
-- mappings
--------------------------------------------------------------------------------
local map = vim.keymap.set
local args = { silent = true }

-- fuzzy find stuff
map("n", " f", [[:call lex#fuzzy#start("lex#fuzzy#goto")<cr>]], args)
-- "  is <c-/> (the mapping only works if it's the literal character)
map("n", "", [[:call lex#fuzzy#start("lex#fuzzy#put")<cr>]], args)
map("i", "", [[<c-o>:call lex#fuzzy#start("lex#fuzzy#insert_put")<cr>]], args)

-- delete the currently selected lines and move them to the scratch file
map("n", " s", function() require'lex.scratch'.move('n') end, args)
map("v", " s", [[:'<,'>lua require'lex.scratch'.move('v')<cr>]], args)

-- todos
map("n", " td", function() require'lex.list'.toggle_sigil('n', '✓') end, args)
map("v", " td", ":lua require'lex.list'.toggle_sigil('v', '✓')<cr>", args)
map("n", " tq", function() require'lex.list'.toggle_sigil('n', '?') end, args)
map("v", " tq", ":lua require'lex.list'.toggle_sigil('v', '?')<cr>", args)
map("n", " tm", function() require'lex.list'.toggle_sigil('n', '~') end, args)
map("v", " tm", ":lua require'lex.list'.toggle_sigil('v', '~')<cr>", args)
