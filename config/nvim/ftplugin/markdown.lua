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

-- "marker-reference" create a reference to the mark on the current line
map("n", " mr", [[:lua vim.fn.setreg('"', require'lex.link'.Reference.from_str():str())<cr>]], { silent = true })
-- "file-marker-reference" create a file-reference to the current file
map("n", " mf", [[:lua vim.fn.setreg('"', require'lex.link'.Reference.from_path():str())<cr>]], { silent = true })

-- insert a marker header
map("n", " mm", "imh<Plug>luasnip-expand-or-jump", { silent = true })
map("n", " ml", "imh<Plug>luasnip-expand-or-jump", { silent = true })
map("n", " mb", "imbh<Plug>luasnip-expand-or-jump", { silent = true })

-- fuzzy find stuff
map("n", " f", [[:call lex#fuzzy#start("lex#fuzzy#goto")<cr>]], { silent = true })
map("n", " m/", [[:call lex#fuzzy#start("lex#fuzzy#put")<cr>]], { silent = true })
-- "  is <c-/> (the mapping only works if it's the literal character)
map("i", "", [[<c-o>:call lex#fuzzy#start("lex#fuzzy#insert_put")<cr>]], { silent = true })

-- delete the currently selected lines and move them to the scratch file
map("n", " s", function() require'lex.scratch'.move('n') end, { silent = true })
map("v", " s", [[:'<,'>lua require'lex.scratch'.move('v')<cr>]], { silent = true })

-- todos
map("n", " td", function() require'lex.list'.toggle_sigil('n', '✓') end, { silent = true })
map("v", " td", ":lua require'lex.list'.toggle_sigil('v', '✓')<cr>", { silent = true })
map("n", " tq", function() require'lex.list'.toggle_sigil('n', '?') end, { silent = true })
map("v", " tq", ":lua require'lex.list'.toggle_sigil('v', '?')<cr>", { silent = true })
map("n", " tm", function() require'lex.list'.toggle_sigil('n', '~') end, { silent = true })
map("v", " tm", ":lua require'lex.list'.toggle_sigil('v', '~')<cr>", { silent = true })
