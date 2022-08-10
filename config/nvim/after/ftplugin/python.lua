vim.keymap.set('n', ' ;', function() require'util'.modify_line_end(':') end, { silent = true, buffer = 0 })
